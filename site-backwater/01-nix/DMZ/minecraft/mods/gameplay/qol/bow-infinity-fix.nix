{ pkgs, ... }:

pkgs.fetchurl {
  name = "BowInfinityFix-1.21-fabric-3.1.0.jar";
  url = "https://cdn.modrinth.com/data/BFENfScW/versions/B7uQ1JNY/BowInfinityFix-1.21-fabric-3.1.0.jar";
  sha256 = "c1c98f5c01c1ca5fbc1e850681d954b76295f597b31bd6b93d93b4295a75fd20";
}
