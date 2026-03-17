{ pkgs, ... }:

pkgs.fetchurl {
  name = "ati-structures-vanilla-1.4.2-mc1.21-plus.jar";
  url = "https://cdn.modrinth.com/data/YWVAO3wq/versions/YhRYQdTK/ATi%20Structures%20Default%20V1.4.2%20%281.21%2B%29.jar";
  sha256 = "0yn1jwkpmm5fps8sm2mkxjkv4ff09g45xjl226nfwsdh1b4zq0kp";
}

