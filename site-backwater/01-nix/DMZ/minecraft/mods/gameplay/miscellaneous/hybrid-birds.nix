{ pkgs, ... }:

pkgs.fetchurl {
  name = "hybrid-birds-1.0.0-fabric-1.21.jar";
  url = "https://cdn.modrinth.com/data/txgXquyE/versions/kdd8vOWW/%5B1.21%5D%20Hybrid%20Birds%201.0.0.jar";
  sha256 = "09fzsn89wb1nfy26id2q9p1w8yzr0q9l66x4v86dw73j5v4bkyg3";
}

