{ pkgs, ... }:

pkgs.fetchurl {
  name = "zombieawareness-fabric-1.21.0-1.13.2.jar";
  url = "https://cdn.modrinth.com/data/mMTOWOaA/versions/lBdgO4GL/zombieawareness-fabric-1.21.0-1.13.2.jar";
  sha256 = "5443eb2cbc3371fe0c5cfe41ad555b1f29293d951763416e2977d9ede05b79a2";
}
