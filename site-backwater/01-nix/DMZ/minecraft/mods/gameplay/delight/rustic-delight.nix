{ pkgs, ... }:

pkgs.fetchurl {
  name = "rusticdelight-fabric-1.21.1-1.5.1.jar";
  url = "https://cdn.modrinth.com/data/foa4fGIH/versions/5IKEinsK/rusticdelight-fabric-1.21.1-1.5.1.jar";
  sha256 = "395dcdf08e34106568dfbb7cf627e8245e20d8cc3a951800aa3b9252304babac";
}
