{ pkgs, ... }:

# Fabric API - Core library mod providing common hooks and intercompatibility measures
# Version: 0.116.8+1.21.1 for MC 1.21.1 (Fabric)
# Update version and hash if Minecraft version changes
# Get version from: https://modrinth.com/mod/fabric-api/versions
pkgs.fetchurl {
  name = "fabric-api-0.116.8+1.21.1.jar";
  url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/3wZtvzew/fabric-api-0.116.8%2B1.21.1.jar";
  sha256 = "06s96l4bjml4ksscp8a5cq9gq4snygr8bn6k9blk3igxwwcy7fkq";
}
