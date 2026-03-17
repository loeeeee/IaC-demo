import ./gateway-template.nix {
  locationName = "tokyo";
  vlan = 30;
  wgInterfaceName = "proton-tokyo";
  wgPrivateKey = "REDACTED";
  wgPublicKey = "REDACTED";
  wgEndpoint = "REDACTED";
  vpnLocationId = "JP#339";
}


