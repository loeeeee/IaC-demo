{ pkgs, ... }:

pkgs.fetchurl {
  name = "geckolib-fabric-1.21.1-4.8.3.jar";
  url = "https://cdn.modrinth.com/data/8BmcQJ2H/versions/fvT8GY10/geckolib-fabric-1.21.1-4.8.3.jar";
  sha256 = "06kj3znd4l26gqy56p3gdk5dp4jsssri1h452q8ck3gn4q7fk1w7";
}
