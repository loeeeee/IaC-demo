{ pkgs, ... }:

pkgs.fetchurl {
  name = "lithium-fabric-0.15.1+mc1.21.1.jar";
  url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/E5eJVp4O/lithium-fabric-0.15.1%2Bmc1.21.1.jar";
  sha256 = "aaa15b94d06486547a36c9c7cb4de0a4ab75dc40e0d9efc33f589251ca8260e0";
}
