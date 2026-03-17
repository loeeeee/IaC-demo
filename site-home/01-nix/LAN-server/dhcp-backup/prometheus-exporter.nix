{
  services.prometheus.exporters.kea = {
    enable = true;
    port = 9547; 
    
    targets = ["/run/kea/dhcp4.sock"];
  };
}

