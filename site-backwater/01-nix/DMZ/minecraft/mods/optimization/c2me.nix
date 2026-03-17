{ pkgs, ... }:

# C2ME (Concurrent Chunk Management Engine) - Performance optimization mod for chunk loading and worldgen
# Version: 0.3.0+alpha.0.362+1.21.1 for MC 1.21.1 (Fabric)
# Update version and hash if Minecraft version changes
# Get version from: https://modrinth.com/mod/c2me-fabric/versions
pkgs.fetchurl {
  name = "c2me-fabric-mc1.21.1-0.3.0+alpha.0.362.jar";
  url = "https://cdn.modrinth.com/data/VSNURh3q/versions/DSqOVCaF/c2me-fabric-mc1.21.1-0.3.0+alpha.0.362.jar";
  sha256 = "15mj94ksywyxa8ywmnn79582kvfgpz0wn5qf4xsvvywlhbppvx71";
}
