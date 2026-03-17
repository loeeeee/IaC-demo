{
  networking.interfaces.eth0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "172.21.0.129";
        prefixLength = 24;
      }
    ];
  };

  networking.defaultGateway = "172.21.0.1";

  networking.nameservers = [ "172.21.0.50" "172.21.0.1"];
}

