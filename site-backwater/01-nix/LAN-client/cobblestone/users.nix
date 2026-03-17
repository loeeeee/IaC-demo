{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes"; #"prohibit-password";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 REDACTED REDACTED@REDACTED"
    "ssh-ed25519 REDACTED REDACTED@REDACTED"
  ];

  users.groups.loe = {
    gid = 2340;
  };

  users.users.loe = {
    isNormalUser = true;
    description = "REDACTED";
    uid = 2340;
    group = "loe";
    extraGroups = [
      "networkmanager"
      "wheel"
      "render"
    ];
    #initialPassword = "SehrSafePassword";
    hashedPassword = "REDACTED";
  };
}
