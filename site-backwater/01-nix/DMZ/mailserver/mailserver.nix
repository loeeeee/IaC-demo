{ config, pkgs, ... }:

{
  services.postfix = {
    enable = true;
    settings = {
      main = {
        relayhost = [ "[wilmington.REDACTED-DOMAIN.TLD]:465" ];
        myhostname = "mail.backwater.REDACTED-DOMAIN.TLD";
        inet_interfaces = "all";
        mynetworks = [ "127.0.0.0/8" "172.22.0.0/16" "192.168.0.0/24"];
        mydestination = [ ];

        # TLS Encryption
        smtp_tls_security_level = "encrypt";
        smtp_tls_wrappermode = "yes";

        # SASL Authentication
        smtp_sasl_auth_enable = "yes";
        smtp_sasl_password_maps = "texthash:/etc/secret/wilmington-password";
        smtp_sasl_security_options = "noanonymous";
      };
    };
  };
}