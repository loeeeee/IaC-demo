{ pkgs, ... }:

# CreativeCore - Core library mod providing GUI API, config system, packet system, and more
# Version: 2.13.24 for MC 1.21.1 (Fabric)
# Requires: Fabric API
# Update version and hash if Minecraft version changes
# Get version from: https://modrinth.com/mod/creativecore/versions
pkgs.fetchurl {
  name = "CreativeCore_FABRIC_v2.13.24_mc1.21.1.jar";
  url = "https://cdn.modrinth.com/data/OsZiaDHq/versions/3ZRFwsQm/CreativeCore_FABRIC_v2.13.24_mc1.21.1.jar";
  sha256 = "0kpwm31v2q30wjvz83mc4cj0w1zf5yc4pgacb0dq94xayn5bp52l";
}
