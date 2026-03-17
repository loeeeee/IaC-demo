{ pkgs, ... }:

pkgs.fetchurl {
  name = "edf-remastered-5.0-beta4.jar";
  url = "https://cdn.modrinth.com/data/HQsBdHGd/versions/zL0UHyGf/edf-remastered-5.0-beta4.jar";
  sha256 = "9bb6942f9d477ff18ea33ebbe61737e5473f4aa699928a4c780c33457b6b4555";
}
