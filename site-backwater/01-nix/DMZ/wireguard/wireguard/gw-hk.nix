import ./gateway-template.nix {
  locationName = "hk";
  vlan = 22;
  wgInterfaceName = "proton-hongkong";
  wgPrivateKey = "REDACTED";
  wgPublicKey = "REDACTED";
  wgEndpoint = "REDACTED";
  vpnLocationId = "HK#37";
}

