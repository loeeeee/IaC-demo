{ pkgs, ... }:

pkgs.fetchurl {
  name = "beb-fabric-1.21-6.0.0.jar";
  url = "https://cdn.modrinth.com/data/pcqEicMM/versions/kcGH3Tr5/BEB-Fabric-1.21-6.0.0.jar";
  sha256 = "10dgylx4lvcqlsfb58m64cgrbpmrj6whs4d0wsxw5cwixrl8d2zg";
}

