{ pkgs, ... }:

pkgs.fetchurl {
  name = "bookshelf-fabric-1.21.1-21.1.80.jar";
  url = "https://cdn.modrinth.com/data/uy4Cnpcm/versions/eRd8PTb9/bookshelf-fabric-1.21.1-21.1.80.jar";
  sha256 = "7525f64eb5584b149e499eadcbb8e584d462ce992e72d31cb535af7aaf0931f4";
}
