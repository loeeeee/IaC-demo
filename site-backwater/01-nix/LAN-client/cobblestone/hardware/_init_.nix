{
  imports = [
    (builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz" + "/module.nix")
    ./disk-config.nix
    ./hardware-acceleration.nix
    ./hardware-configuration.nix
  ];
}