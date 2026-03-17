#!/run/current-system/sw/bin/bash

# This script should be run from the root of the repository.

link_custom_modules() {
    local network_area=$1
    local config=$2
    local root=$(pwd)
    local src="$root/site-home/01-nix/_common/"
    local dest="$root/site-home/01-nix/$network_area/$config/custom-modules"
    rm -rf $dest
    ln -s $src $dest
}

# LAN-server
link_custom_modules "LAN-server" "unbound-master"
link_custom_modules "LAN-server" "unbound-backup"
link_custom_modules "LAN-server" "bind"
# DMZ
link_custom_modules "DMZ" "ws-tunnel"
link_custom_modules "DMZ" "wireguard"

echo "Custom modules created successfully."

