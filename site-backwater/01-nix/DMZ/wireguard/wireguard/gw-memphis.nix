import ./gateway-template.nix {
  locationName = "memphis";
  vlan = 18;
  wgInterfaceName = "proton-memphis";
  wgPrivateKey = "REDACTED";
  wgPublicKey = "REDACTED";
  wgEndpoint = "REDACTED";
  vpnLocationId = "US-TN#23 (Memphis)";
}

