{
  services.prometheus.exporters.kea = {
    enable = true;
    port = 9167; 
    
    targets = ["/run/kea/dhcp4.sock"];
  };
}