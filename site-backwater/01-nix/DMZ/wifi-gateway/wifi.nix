{ config, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;
  
  networking.wireless = {
    enable = true;  # Note: This disables NetworkManager by default!
    
    # Allow wpa_supplicant to read the certs
    allowAuxiliaryImperativeNetworks = true;

    networks = {
      "vuNet" = {
        auth = ''
          key_mgmt=WPA-EAP
          eap=TLS
          identity="REDACTED@REDACTED-UNIVERSITY.EDU"
          
          # Domain match for security (from your screenshot)
          domain_suffix_match="REDACTED-RADIUS.REDACTED-UNIVERSITY.EDU"

          # Certificate paths
          ca_cert="/etc/nixos/certs/ca.pem"
          client_cert="/etc/nixos/certs/client.crt"
          private_key="/etc/nixos/certs/client.p12"
          
          # The password for the .p12 file
          private_key_passwd="REDACTED"
        '';
      };
    };
  };
}

