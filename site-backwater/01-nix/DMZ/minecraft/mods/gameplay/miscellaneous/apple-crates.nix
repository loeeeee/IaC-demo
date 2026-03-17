{ pkgs, ... }:

pkgs.fetchurl {
  name = "applecrates-fabric-1.21.1-4.0.1.jar";
  url = "https://cdn.modrinth.com/data/oQaAgvJv/versions/mcV0VpX8/applecrates-fabric-1.21.1-4.0.1.jar";
  sha256 = "fd45be85400415b90a6dd4c69001a261ba1012e7dbb50a06a47ef1fe8b8f6333";
}
