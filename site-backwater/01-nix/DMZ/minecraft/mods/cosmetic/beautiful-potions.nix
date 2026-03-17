{ pkgs, ... }:

pkgs.fetchurl {
  name = "btp-fabric-1.21.1-1.0.2.jar";
  url = "https://cdn.modrinth.com/data/H3a6cFKr/versions/MThKrdnz/BTP-Fabric-1.21.1-1.0.2.jar";
  sha256 = "03317qlsf58p1camc8ns27wdiccdkpb8v6c9zwf28qc0yw1s5gbq";
}

