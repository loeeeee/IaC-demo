import ./gateway-template.nix {
  locationName = "berlin";
  vlan = 26;
  wgInterfaceName = "proton-berlin";
  wgPrivateKey = "REDACTED";
  wgPublicKey = "REDACTED";
  wgEndpoint = "REDACTED";
  vpnLocationId = "DE#488";
}


