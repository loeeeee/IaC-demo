{ pkgs, ... }:

pkgs.fetchurl {
  name = "surveyor-1.2.1+1.21.jar";
  url = "https://cdn.modrinth.com/data/4KjqhPc9/versions/6UH2PpaK/surveyor-1.2.1%2B1.21.jar";
  sha256 = "0cg3mhkwg955z291yfzv1ghgifrhqim2fjmjj1k39pb3chf58h2r";
}
