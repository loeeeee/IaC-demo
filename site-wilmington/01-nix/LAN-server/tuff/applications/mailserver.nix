{
  config,
  ...
}:

let
  domain = "mail.REDACTED-DOMAIN.TLD";
in
{
  imports = [
    (builtins.fetchTarball {
      # Pick a release version you are interested in and set its hash, e.g.
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/master/nixos-mailserver-master.tar.gz";
      # release="nixos-25.11"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
      sha256 = "17mb8xzpmld4pzzlvsvgrih9i5162hqkc17z2xwrg8k63gsl7kcj";
    })
  ];

  security.acme = {
    certs."${domain}" = {
      domain = "*.${domain}";
      extraDomainNames = [ domain ];
      dnsProvider = "porkbun";
      environmentFile = "/etc/secret/acme-porkbun-env";
      # Use public DNS resolver for propagation check (avoids local DNS cache issues)
      dnsResolver = "1.1.1.1:53";
      # Skip local propagation check - let Let's Encrypt verify directly
      # (Porkbun DNS can be slow to propagate to external resolvers)
      dnsPropagationCheck = false;
      # Reload HAProxy when certificate is renewed
      # reloadServices = [ "haproxy" ];
    };
  };

  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "mail.REDACTED-DOMAIN.TLD";
    domains = [ "REDACTED-DOMAIN.TLD" ];
    localDnsResolver = false;

    # reference an existing ACME configuration
    x509.useACMEHost = config.mailserver.fqdn;

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -s'
    loginAccounts = {
      "REDACTED" = {
        hashedPasswordFile = "/etc/secret/mailserver-loe_bi";
        aliases = [
          "admin@REDACTED-DOMAIN.TLD"
          "REDACTED@REDACTED-DOMAIN.TLD"
        ];
      };
      "backwater" = {
        hashedPasswordFile = "/etc/secret/mailserver-backwater";
        sendOnly = true;
        aliases = [ "backwater@REDACTED-DOMAIN.TLD" ];
      };
      "wilmington" = {
        hashedPasswordFile = "/etc/secret/mailserver-wilmington";
        sendOnly = true;
        aliases = [ "wilmington@REDACTED-DOMAIN.TLD" ];
      };
    };
  };
}