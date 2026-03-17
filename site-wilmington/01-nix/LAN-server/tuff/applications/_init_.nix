{
  imports = [
    ./gatus/_init_.nix
    ./haproxy/_init_.nix
    ./bind.nix
    ./harmonia.nix
    ./mailserver.nix
    ./remote-builder.nix
    ./speedtest.nix
    ./wireguard-backwater.nix
    ./ws-tunnel-server.nix
  ];
}