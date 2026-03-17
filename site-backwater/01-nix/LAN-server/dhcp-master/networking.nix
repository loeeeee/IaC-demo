{
  networking.interfaces.eth0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "172.22.0.108";
        prefixLength = 24;
      }
    ];
  };

  networking.defaultGateway = "172.22.0.1";

  networking.nameservers = [ "172.22.0.50" "172.22.0.1"];
}