{ config, pkgs, modulesPath, ... }:

{
  # Configure user qbittorrent
  users.groups.qbittorrent = {
    gid = 2349;
  };
  users.users.qbittorrent = {
    isSystemUser = true;
    uid = 2349;
    group = "qbittorrent";
    home = "/var/lib/qbittorrent";
    createHome = true;
    extraGroups = [ "network" ];
  };

  services.qbittorrent = {
    enable = true;
    user = "qbittorrent";
    group = "qbittorrent";
    profileDir = "/var/lib/qbittorrent";
    webuiPort = 8080;
    # https://github.com/qbittorrent/qBittorrent/wiki/Explanation-of-Options-in-qBittorrent
    # This will DELETE the configuration on the server!
    # serverConfig = {
    #   LegalNotice.Accepted = true;
    #   Preferences = {
    #     WebUI = {
    #       Address = "172.22.0.111";
    #       Username = "loe";
    #       Password_PBKDF2 = "@ByteArray(PaR8CxqbV60FlnfvS5Mdcg==:9E/b3HvxQFyzjcdCNT++4UgIW1pSmnDPOqO09tJDP/+rhFX01n4skgpBOmsJ3gkh5w7VghsNRDE0MfzJmRfxrQ==)";
    #     };
    #     General.Locale = "en";
    #   };
    # };
  };
}
