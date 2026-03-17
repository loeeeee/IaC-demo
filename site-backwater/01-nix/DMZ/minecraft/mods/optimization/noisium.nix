{ pkgs, ... }:

pkgs.fetchurl {
  name = "noisium-fabric-2.3.0+mc1.21-1.21.1.jar";
  url = "https://cdn.modrinth.com/data/KuNKN7d2/versions/4sGQgiu2/noisium-fabric-2.3.0%2Bmc1.21-1.21.1.jar";
  sha256 = "11fg80rsrpa7az3pqgj9pgkwd95pkqhf3swmd5wbfdp9c4w1cb63";
}

