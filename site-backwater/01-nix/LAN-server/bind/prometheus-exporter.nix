{
  services.prometheus.exporters.bind = {
    enable = true;
    port = 9167;
    bindGroups = [
        "server"
        "view"
    ];
    bindURI = "http://127.0.0.1:8053";
  };
}