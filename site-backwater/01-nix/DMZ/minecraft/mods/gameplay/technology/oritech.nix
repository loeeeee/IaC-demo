{ pkgs, ... }:

pkgs.fetchurl {
  name = "oritech-fabric-1.21.1-1.0.0.jar";
  url = "https://cdn.modrinth.com/data/4sYI62kA/versions/1aXJP4f8/oritech-fabric-1.21.1-1.0.0.jar";
  sha256 = "13sg524d3ngbr7jj7mgr5dvffhf3kq56ai0w4k6r4kiyqkgvyqgc";
}