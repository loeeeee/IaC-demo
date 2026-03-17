#!/run/current-system/sw/bin/bash

# This script should be run from the root of the repository.

link_custom_modules() {
    local network_area=$1
    local config=$2
    local root=$(pwd)
    local src="$root/site-backwater/01-nix/_common/"
    local dest="$root/site-backwater/01-nix/$network_area/$config/custom-modules"
    rm -rf $dest
    ln -s $src $dest
}

# LAN-server
link_custom_modules "LAN-server" "code-server"
link_custom_modules "LAN-server" "dhcp-master"
link_custom_modules "LAN-server" "dhcp-backup"
link_custom_modules "LAN-server" "grafana"
link_custom_modules "LAN-server" "jellyfin"
link_custom_modules "LAN-server" "k3s-agent-0"
link_custom_modules "LAN-server" "k3s-agent-1"
link_custom_modules "LAN-server" "k3s-server"
link_custom_modules "LAN-server" "llama-cpp"
link_custom_modules "LAN-server" "postgresql"
link_custom_modules "LAN-server" "prometheus"
link_custom_modules "LAN-server" "unbound-master"
link_custom_modules "LAN-server" "unbound-backup"
link_custom_modules "LAN-server" "victorialogs"
link_custom_modules "LAN-server" "lldap"
link_custom_modules "LAN-server" "authelia"
link_custom_modules "LAN-server" "immich"
link_custom_modules "LAN-server" "redis"
link_custom_modules "LAN-server" "kde-desktop"
link_custom_modules "LAN-server" "gpu-server"
# DMZ
link_custom_modules "DMZ" "dufs"
link_custom_modules "DMZ" "haproxy"
link_custom_modules "DMZ" "mailserver"
link_custom_modules "DMZ" "qbittorrent"
link_custom_modules "DMZ" "speedtest"
link_custom_modules "DMZ" "wireguard"
link_custom_modules "DMZ" "ws-tunnel"
link_custom_modules "DMZ" "wifi-gateway"
# LAN-client
link_custom_modules "LAN-client" "game-server"
link_custom_modules "LAN-client" "cobblestone"

echo "Custom modules created successfully."