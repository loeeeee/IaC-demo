let
  vlServer = "172.22.0.107";
  vlPort = "5514"; 
in
{
  services.rsyslogd = {
    enable = true;
    
    # This config reads from the local journal and forwards it
    extraConfig = ''
      # Load the imjournal module to read from systemd-journald
      module(load="imjournal" StateFile="imjournal.state")

      # Forward everything to VictoriaLogs via TCP
      action(type="omfwd" Target="${vlServer}" Port="${vlPort}" Protocol="tcp")
    '';
  };

  # Clean up journal logs locally so the LXC disk doesn't fill up
  services.journald.extraConfig = ''
    SystemMaxUse=100M
  '';

  systemd.services.rsyslogd = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
}
