{ pkgs, ... }:

pkgs.fetchurl {
  name = "Statusbot-20.0-Fabric.jar";
  url = "https://cdn.modrinth.com/data/G9ZpI0bU/versions/P95RK8Z5/Statusbot-20.0-Fabric.jar";
  sha256 = "1s2d7nabxgkhmi9fdi5b5m0qmzjas08rj6qggnczk2x81q62wbjj";
}
