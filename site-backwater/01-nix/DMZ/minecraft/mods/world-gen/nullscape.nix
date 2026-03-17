{ pkgs, ... }:

# Nullscape - Transforms the boring Vanilla end into an alien dimension with surreal terrain
# Version: 1.2.14 for MC 1.21.x (Fabric/Forge/NeoForge/Quilt)
# Update version and hash if Minecraft version changes
# Get version from: https://modrinth.com/datapack/nullscape/versions
pkgs.fetchurl {
  name = "Nullscape_1.21.x_v1.2.14.jar";
  url = "https://cdn.modrinth.com/data/LPjGiSO4/versions/3fv8O3xX/Nullscape_1.21.x_v1.2.14.jar";
  sha256 = "1blkbi16yb5gb4jwhncqg2rrk1nz5h0qxh8n07jkb4v5vbywcjc7";
}
