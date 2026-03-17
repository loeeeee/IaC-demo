import ./gateway-template.nix {
  locationName = "seoul";
  vlan = 34;
  wgInterfaceName = "proton-seoul";
  wgPrivateKey = "REDACTED";
  wgPublicKey = "REDACTED";
  wgEndpoint = "REDACTED";
  vpnLocationId = "KR#32";
}
