{ pkgs, ... }:

pkgs.fetchurl {
  name = "moonlight-1.21-2.29.16-fabric.jar";
  url = "https://cdn.modrinth.com/data/twkfQtEc/versions/SyIbV8py/moonlight-1.21-2.29.16-fabric.jar";
  sha256 = "43dde15af961ae940e66d5cd6d9dfe98849ae058845307c5e48c3fd70026dca5";
}
