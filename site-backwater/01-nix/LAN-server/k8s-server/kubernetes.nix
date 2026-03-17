{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = "rigil";
    apiserverAddress = "https://172.22.0.106:6443";
    easyCerts = true;
    apiserver = {
      securePort = 6443;
      advertiseAddress = "172.22.0.106";
    };
    addons.dns.enable = true;

    addonManager.enable = true;
    addonManager.addons = {
      nginx-ingress = builtins.fromJSON (builtins.readFile ./k8s-addon/nginx-ingress.json);
    };
  };
}
