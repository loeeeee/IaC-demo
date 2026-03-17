{ pkgs, ... }:

pkgs.fetchurl {
  name = "midnightlib-fabric-1.9.2+1.21.1.jar";
  url = "https://cdn.modrinth.com/data/codAaoxh/versions/3tCMjbnf/midnightlib-fabric-1.9.2%2B1.21.1.jar";
  sha256 = "8bb0239ae90ae97c37e5c6d2530e4a6fb718714aa14254aff9f1677bed83628a";
}
