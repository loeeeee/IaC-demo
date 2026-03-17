{ pkgs, ... }:

pkgs.fetchurl {
  name = "bclib-21.0.13.jar";
  url = "https://cdn.modrinth.com/data/BgNRHReB/versions/TxWM7AW8/bclib-21.0.13.jar";
  sha256 = "c1507799e31b55264197431f1b6139650303b430093c89bb0a2d9901740b5a7c";
}
