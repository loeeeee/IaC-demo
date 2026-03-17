#!/usr/bin/env python3
"""
Concurrent deployment driver for site configurations.
"""

from __future__ import annotations

import argparse
import logging
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, Future, as_completed
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, List, Sequence

try:
    import yaml
except ImportError as exc:
    print("Missing dependency: pyyaml")
    print("Please ensure you are running inside nix-shell shell.nix")
    raise SystemExit(1) from exc

try:
    from tqdm import tqdm
except ImportError as exc:
    print("Missing dependency: tqdm")
    print("Please ensure you are running inside nix-shell shell.nix")
    raise SystemExit(1) from exc


@dataclass(frozen=True)
class DeployTarget:
    site: str
    config: str
    host: str
    deploy: bool
    update: bool
    priority: int
    network_area: str = ""

    def source_path(self) -> str:
        if self.network_area:
            return f"site-{self.site}/01-nix/{self.network_area}/{self.config}/"
        return f"site-{self.site}/01-nix/{self.config}/"

    def destination(self) -> str:
        return f"root@{self.host}:/etc/nixos/"

    def label(self) -> str:
        return f"{self.site}:{self.config}@{self.host}"


@dataclass(frozen=True)
class DeployOptions:
    dry_run: bool
    skip_rebuild: bool
    max_workers: int


@dataclass
class DeploymentResult:
    target: DeployTarget
    changed: bool
    success: bool
    message: str
    details: str | None = None


class DeploymentError(Exception):
    """Raised when a deployment step fails."""


def sanitize_filename(label: str) -> str:
    """Convert target label to filesystem-safe filename."""
    return label.replace(":", "-").replace("@", "-")


def load_targets_from_yaml(yaml_path: Path) -> List[DeployTarget]:
    if not yaml_path.exists():
        raise DeploymentError(f"YAML file not found: {yaml_path}")
    
    try:
        with yaml_path.open("r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
    except yaml.YAMLError as exc:
        raise DeploymentError(f"Failed to parse YAML file {yaml_path}: {exc}") from exc
    except OSError as exc:
        raise DeploymentError(f"Failed to read YAML file {yaml_path}: {exc}") from exc
    
    if not isinstance(data, dict) or "targets" not in data:
        raise DeploymentError(f"YAML file {yaml_path} must contain a 'targets' key")
    
    targets = []
    for idx, entry in enumerate(data["targets"], start=1):
        if not isinstance(entry, dict):
            raise DeploymentError(f"Target {idx} in YAML must be a dictionary")
        
        required_fields = ["site", "config", "host", "deploy", "update", "priority"]
        missing = [field for field in required_fields if field not in entry]
        if missing:
            raise DeploymentError(
                f"Target {idx} in YAML missing required fields: {', '.join(missing)}"
            )
        
        try:
            priority = int(entry["priority"])
            network_area = str(entry.get("network_area", ""))
            target = DeployTarget(
                site=str(entry["site"]),
                config=str(entry["config"]),
                host=str(entry["host"]),
                deploy=bool(entry["deploy"]),
                update=bool(entry["update"]),
                priority=priority,
                network_area=network_area,
            )
            targets.append(target)
        except (TypeError, ValueError) as exc:
            raise DeploymentError(
                f"Target {idx} in YAML has invalid field types: {exc}"
            ) from exc
    
    return targets


def filter_targets(
    targets: Iterable[DeployTarget],
    sites: List[str] | None,
    configs: List[str] | None,
    hosts: List[str] | None,
    operation_mode: str | None = None,
) -> List[DeployTarget]:
    def matches(target: DeployTarget) -> bool:
        site_ok = not sites or target.site in sites
        config_ok = not configs or target.config in configs
        host_ok = not hosts or target.host in hosts
        
        if operation_mode == "deploy":
            operation_ok = target.deploy
        elif operation_mode == "update":
            operation_ok = target.update
        else:
            operation_ok = True
        
        return site_ok and config_ok and host_ok and operation_ok

    return [target for target in targets if matches(target)]


def configure_logging(log_file: Path, log_level: int) -> logging.Logger:
    """Configure main logger for high-level operations."""
    logger = logging.getLogger("deploy")
    logger.setLevel(log_level)
    logger.handlers.clear()

    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(log_level)
    console_handler.setFormatter(
        logging.Formatter("[%(levelname)s] %(message)s")
    )

    file_handler = logging.FileHandler(log_file, encoding="utf-8")
    file_handler.setLevel(log_level)
    file_handler.setFormatter(
        logging.Formatter(
            "%(asctime)s %(levelname)s %(name)s - %(message)s",
            "%Y-%m-%d %H:%M:%S",
        )
    )

    logger.addHandler(console_handler)
    logger.addHandler(file_handler)
    return logger


def configure_target_logging(target: DeployTarget, log_dir: Path, log_level: int) -> logging.Logger:
    """Configure logger for individual target with detailed logging."""
    logger_name = f"deploy.target.{target.label()}"
    logger = logging.getLogger(logger_name)
    logger.setLevel(log_level)
    logger.handlers.clear()
    logger.propagate = False

    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(log_level)
    console_handler.setFormatter(
        logging.Formatter("[%(levelname)s] %(message)s")
    )

    safe_filename = sanitize_filename(target.label())
    log_file = log_dir / f"{safe_filename}.log"
    file_handler = logging.FileHandler(log_file, encoding="utf-8")
    file_handler.setLevel(log_level)
    file_handler.setFormatter(
        logging.Formatter(
            "%(asctime)s %(levelname)s %(name)s - %(message)s",
            "%Y-%m-%d %H:%M:%S",
        )
    )

    logger.addHandler(console_handler)
    logger.addHandler(file_handler)
    return logger


def run_command(command: Sequence[str]) -> subprocess.CompletedProcess:
    result = subprocess.run(
        command,
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise DeploymentError(
            f"Command failed ({' '.join(command)}): {result.stderr.strip()}"
        )
    return result


def check_changes(target: DeployTarget) -> tuple[bool, str]:
    """Check for changes in both main config (excluding secret/) and secret/ folder."""
    src = target.source_path()
    dest = target.destination()
    
    # Check main config excluding secret/
    command = [
        "rsync",
        "-a",
        "--delete",
        "--checksum",
        "-L",
        "--dry-run",
        "--itemize-changes",
        "--out-format=%i %n%L",
        "--exclude", "secret/",
        src,
        dest,
    ]
    result = run_command(command)
    main_output = result.stdout.strip()
    
    # Check secret/ folder separately
    secret_src = Path(src) / "secret"
    secret_dest = f"root@{target.host}:/etc/secret/"
    secret_output = ""
    if secret_src.exists():
        secret_command = [
            "rsync",
            "-a",
            "--delete",
            "--checksum",
            "-L",
            "--dry-run",
            "--itemize-changes",
            "--out-format=%i %n%L",
            str(secret_src) + "/",
            secret_dest,
        ]
        secret_result = run_command(secret_command)
        secret_output = secret_result.stdout.strip()
    
    # Combine outputs
    combined_output = main_output
    if secret_output:
        if combined_output:
            combined_output += "\n"
        combined_output += "[secrets]\n" + secret_output
    
    return bool(combined_output), combined_output


def synchronize(target: DeployTarget) -> None:
    """Synchronize main configuration excluding secret/ folder."""
    command = [
        "rsync",
        "-a",
        "--delete",
        "--checksum",
        "-L",
        "--exclude", "secret/",
        target.source_path(),
        target.destination(),
    ]
    run_command(command)


def synchronize_secrets(target: DeployTarget) -> None:
    """Synchronize secret/ folder to /etc/secret/ on the remote host."""
    src = Path(target.source_path()) / "secret"
    if not src.exists():
        return
    dest = f"root@{target.host}:/etc/secret/"
    command = [
        "rsync",
        "-a",
        "--delete",
        "--checksum",
        "-L",
        str(src) + "/",
        dest,
    ]
    run_command(command)


def rebuild(target: DeployTarget) -> None:
    command = [
        "ssh",
        f"root@{target.host}",
        "nixos-rebuild",
        "switch",
    ]
    run_command(command)


def check_host_reachable(host: str) -> bool:
    result = subprocess.run(
        ["ping", "-c", "1", "-W", "3", host],
        capture_output=True,
        text=True,
    )
    return result.returncode == 0


def get_system_info(target: DeployTarget) -> str:
    version_cmd = ["ssh", f"root@{target.host}", "nixos-version"]
    generation_cmd = [
        "ssh",
        f"root@{target.host}",
        "nix-env",
        "--list-generations",
        "--profile",
        "/nix/var/nix/profiles/system",
    ]
    
    version = "unknown"
    try:
        version_result = run_command(version_cmd)
        version = version_result.stdout.strip()
    except DeploymentError:
        version = "failed to retrieve"
    
    current_gen = "unknown"
    try:
        generation_result = run_command(generation_cmd)
        generations = generation_result.stdout.strip().split("\n")
        current_gen = generations[-1] if generations else "unknown"
    except DeploymentError:
        current_gen = "failed to retrieve"
    
    return f"{version}\nCurrent generation: {current_gen}"


def update_target(target: DeployTarget, target_logger: logging.Logger) -> DeploymentResult:
    target_logger.info("Checking reachability for %s", target.label())
    if not check_host_reachable(target.host):
        target_logger.warning("Cannot reach %s (%s). Skipping.", target.config, target.host)
        return DeploymentResult(
            target, False, False, f"Host unreachable: {target.host}"
        )
    
    try:
        target_logger.info("Current system info for %s", target.label())
        system_info_before = get_system_info(target)
        target_logger.info("%s", system_info_before)
        
        target_logger.info("Updating nixpkgs channel on %s", target.label())
        run_command(["ssh", f"root@{target.host}", "nix-channel", "--update"])
        
        target_logger.info("Upgrading system packages on %s", target.label())
        run_command([
            "ssh",
            f"root@{target.host}",
            "nixos-rebuild",
            "switch",
            "--upgrade",
        ])
        
        target_logger.info("Cleaning up old generations and unused packages on %s", target.label())
        run_command([
            "ssh",
            f"root@{target.host}",
            "nix-collect-garbage",
            "-d",
        ])
        
        target_logger.info("Updated system info for %s", target.label())
        system_info_after = get_system_info(target)
        target_logger.info("%s", system_info_after)
        
        return DeploymentResult(
            target, True, True, "Packages updated successfully", system_info_after
        )
    except DeploymentError as exc:
        target_logger.error("Update failed for %s: %s", target.label(), exc)
        return DeploymentResult(target, False, False, f"Update failed: {exc}")


def deploy_target(target: DeployTarget, options: DeployOptions, target_logger: logging.Logger) -> DeploymentResult:
    target_logger.info("Checking %s", target.label())
    changed, details = check_changes(target)
    if not changed:
        return DeploymentResult(target, False, True, "No changes detected")

    target_logger.info("Changes detected for %s", target.label())
    if options.dry_run:
        target_logger.info("Dry run enabled; skipping apply for %s", target.label())
        return DeploymentResult(target, True, True, "Dry run only", details)

    synchronize(target)
    synchronize_secrets(target)
    if options.skip_rebuild:
        target_logger.info("Skipping rebuild for %s", target.label())
    else:
        rebuild(target)

    return DeploymentResult(target, True, True, "Configuration applied", details)


def determine_workers(requested: int, total: int) -> int:
    if total <= 1:
        return 1
    if requested > 0:
        return min(requested, total)
    return min(8, total)


def group_by_priority(targets: List[DeployTarget]) -> List[List[DeployTarget]]:
    priority_groups: dict[int, List[DeployTarget]] = {}
    for target in targets:
        if target.priority not in priority_groups:
            priority_groups[target.priority] = []
        priority_groups[target.priority].append(target)
    
    sorted_priorities = sorted(priority_groups.keys())
    return [priority_groups[pri] for pri in sorted_priorities]


def execute_batch(
    batch: List[DeployTarget],
    options: DeployOptions,
    logger: logging.Logger,
    operation_mode: str,
    log_dir: Path,
    log_level: int,
) -> List[DeploymentResult]:
    results: List[DeploymentResult] = []
    
    if len(batch) <= 1:
        for target in batch:
            target_logger = configure_target_logging(target, log_dir, log_level)
            if operation_mode == "update":
                result = update_target(target, target_logger)
            else:
                result = deploy_target(target, options, target_logger)
            results.append(result)
        return results

    max_workers = determine_workers(options.max_workers, len(batch))
    operation_name = "updates" if operation_mode == "update" else "deployments"
    logger.info("Running %d %s concurrently for priority %d", max_workers, operation_name, batch[0].priority)

    def execute_target(target: DeployTarget) -> DeploymentResult:
        target_logger = configure_target_logging(target, log_dir, log_level)
        if operation_mode == "update":
            return update_target(target, target_logger)
        return deploy_target(target, options, target_logger)

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        future_map: dict[Future[DeploymentResult], DeployTarget] = {
            executor.submit(execute_target, target): target
            for target in batch
        }
        progress = tqdm(total=len(future_map), desc=operation_name.capitalize(), unit="target")
        try:
            for future in as_completed(future_map):
                target = future_map[future]
                try:
                    result = future.result()
                    results.append(result)
                except DeploymentError as exc:
                    operation_name_single = "update" if operation_mode == "update" else "deployment"
                    logger.error("%s failed for %s: %s", operation_name_single.capitalize(), target.label(), exc)
                    for pending in future_map:
                        if not pending.done():
                            pending.cancel()
                    raise
                finally:
                    progress.update(1)
        finally:
            progress.close()
    return results


def execute_concurrently(
    targets: List[DeployTarget],
    options: DeployOptions,
    logger: logging.Logger,
    operation_mode: str = "deploy",
    log_dir: Path = Path("log"),
    log_level: int = logging.INFO,
) -> List[DeploymentResult]:
    results: List[DeploymentResult] = []
    
    priority_batches = group_by_priority(targets)
    operation_name = "update" if operation_mode == "update" else "deployment"
    
    for batch in priority_batches:
        priority = batch[0].priority
        logger.info("Processing priority %d batch with %d target(s)", priority, len(batch))
        
        batch_results = execute_batch(batch, options, logger, operation_mode, log_dir, log_level)
        results.extend(batch_results)
        
        if operation_mode == "deploy":
            failures = [r for r in batch_results if not r.success]
            if failures:
                logger.error("%s failed in priority %d batch, halting", operation_name.capitalize(), priority)
                return results
    
    return results


def summarize(results: List[DeploymentResult]) -> tuple[int, int]:
    changed = sum(1 for result in results if result.changed)
    failures = sum(1 for result in results if not result.success)
    return changed, failures


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Deploy or update NixOS configurations concurrently."
    )
    parser.add_argument("--site", action="append", help="Restrict to specific site(s).")
    parser.add_argument("--config", action="append", help="Restrict to configuration name(s).")
    parser.add_argument("--host", action="append", help="Restrict to host IP(s).")
    parser.add_argument("--update", action="store_true", help="Update packages instead of deploying configurations.")
    parser.add_argument("--dry-run", action="store_true", help="Only detect changes, do not sync or rebuild (deploy mode only).")
    parser.add_argument("--skip-rebuild", action="store_true", help="Skip remote nixos-rebuild step (deploy mode only).")
    parser.add_argument("--max-workers", type=int, default=0, help="Maximum concurrent operations per priority batch (auto when 0).")
    parser.add_argument("--log-file", default="log/deploy.log", help="Path to detailed log file.")
    parser.add_argument("--yaml-file", default="host.yaml", help="Path to YAML configuration file.")
    parser.add_argument("--preview", action="store_true", help="Print selected targets and exit.")
    parser.add_argument("--verbose", action="store_true", help="Enable DEBUG logging.")
    return parser


def preview_targets(targets: List[DeployTarget]) -> None:
    if not targets:
        print("No targets selected.")
        return
    print("Selected targets:")
    for target in targets:
        print(f"- {target.label()} -> {target.source_path()} -> {target.destination()}")


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    operation_mode = "update" if args.update else "deploy"
    
    try:
        all_targets = load_targets_from_yaml(Path(args.yaml_file))
    except DeploymentError as exc:
        print(f"Error loading targets: {exc}")
        return 1

    targets = filter_targets(
        all_targets,
        args.site,
        args.config,
        args.host,
        operation_mode,
    )
    if not targets:
        print("No matching targets.")
        return 1

    if args.preview:
        preview_targets(targets)
        return 0

    log_dir = Path("log")
    log_dir.mkdir(exist_ok=True)

    log_file = Path(args.log_file)
    if not log_file.is_absolute() and not str(log_file).startswith("log/"):
        log_file = log_dir / log_file.name

    log_level = logging.DEBUG if args.verbose else logging.INFO
    logger = configure_logging(log_file, log_level)
    options = DeployOptions(
        dry_run=args.dry_run,
        skip_rebuild=args.skip_rebuild,
        max_workers=args.max_workers,
    )

    operation_name = "update" if operation_mode == "update" else "deployment"
    logger.info("Starting %s for %d target(s)", operation_name, len(targets))
    try:
        results = execute_concurrently(targets, options, logger, operation_mode, log_dir, log_level)
    except DeploymentError:
        logger.error("%s halted due to failure.", operation_name.capitalize())
        return 1

    changed, failures = summarize(results)
    logger.info("%s complete: %d changed, %d failures", operation_name.capitalize(), changed, failures)
    
    summary_title = f"{operation_name.capitalize()} summary"
    print(summary_title)
    print("-" * len(summary_title))
    for result in results:
        status = "ok" if result.success else "failed"
        change_flag = "changed" if result.changed else "no-change"
        print(f"{status:>7} | {change_flag:>9} | {result.target.label()} | {result.message}")

    print("-" * len(summary_title))
    print(f"Total: {len(results)} | Changed: {changed} | Failures: {failures}")
    return 0 if failures == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())

