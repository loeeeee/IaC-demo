{ pkgs, ... }:

# ChoiceTheorem's Overhauled Village - Enhances and creates new villages and pillager outposts
# Version: 3.6.1 for MC 1.21.1 (Fabric)
# Requires: Lithostitched
# Update version and hash if Minecraft version changes
# Get version from: https://modrinth.com/mod/ct-overhaul-village/versions
pkgs.fetchurl {
  name = "ctov-1.21.1-3.6.1.jar";
  url = "https://cdn.modrinth.com/data/fgmhI8kH/versions/GkrjwPMq/%5BFabric%5Dctov-3.6.1.jar";
  sha256 = "09prwf1k9s9pirw67bb27093yip7v00niv7z12fp92njl6g3abnv";
}
