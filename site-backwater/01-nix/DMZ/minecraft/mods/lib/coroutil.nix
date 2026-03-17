{ pkgs, ... }:

pkgs.fetchurl {
  name = "coroutil-fabric-1.21.1-1.3.8.jar";
  url = "https://cdn.modrinth.com/data/rLLJ1OZM/versions/U0NUocji/coroutil-fabric-1.21.1-1.3.8.jar";
  sha256 = "d4664c92c17ce9608ab4b36f760b2e988ae2de1660d70d746badb3ed5a033e30";
}
