{ config, pkgs, modulesPath, lib, ... }:

{
  # Configure user loe
  users.groups.loe = {
    gid=2340;
  };
  users.users.loe = {
    isNormalUser = true;
    uid = 2340;
    group = "loe";
    home = "/home/loe";
    createHome = true;
    extraGroups = [ "render" "video" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 REDACTED REDACTED@REDACTED"
      "ssh-ed25519 REDACTED REDACTED@REDACTED"
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages including dependencies
  environment.systemPackages = with pkgs; [
    texlive.combined.scheme-full
    btop
    gnupg

    # Media processing
    darktable
    ffmpeg_8-full

    # Tools
    nodejs_24
    opentofu
    pandoc
    screen
    wget
    unzip
    uv
    tree
    # cursor-cli
    lbzip2
    dig
    jq
    postgresql_18_jit # For pgbench
    code-server
    numactl
    inetutils

    ## R tools
    (rWrapper.override {
      packages = with pkgs.rPackages; [
        ggplot2
        dplyr
        knitr
        rmarkdown
        pandoc
        languageserver
        data_table
      ];
    })

  ## Python tools
  (python313.withPackages (ps: with ps; [
      pip
      requests

      ### Jupyter
      jupyter
      ipykernel

      ### Visualization
      matplotlib
      seaborn

      ### Observerbility
      tqdm

      ### ML
      numpy
      pandas
      scikit-learn

      ### NLP
      spacy
      spacy-models.en_core_web_sm

      ### DL
      torch
      torchaudio
      torchvision

      ### Spark
      pyspark
      pyarrow
      grpcio
      grpcio-tools
      grpcio-status
    ]))

    ## Benchmark
    # geekbench_6

    mermaid-filter
  ];

  # Enable code-server service
  services.code-server = {
    enable = true;
    package = pkgs.code-server;
    port = 8080;
    auth = "none";
    user = "loe";
    group = "loe";
    host = "172.22.0.130";
  };

  programs.nix-ld.enable = true;
}
