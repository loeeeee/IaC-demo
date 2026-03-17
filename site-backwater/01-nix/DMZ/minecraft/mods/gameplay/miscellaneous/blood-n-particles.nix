{ pkgs, ... }:

pkgs.fetchurl {
  name = "blood-n-particles-fabric-1.4.0-mc1.21.1.jar";
  url = "https://cdn.modrinth.com/data/GMc9eFJe/versions/ZiF1i6xN/Blood%20N%27%20Particles%20v1.4.0%20-%20Fabric%201.21.1.jar";
  sha256 = "0mk0fmc7hs5m295rfr71knxv7cv2z6dqgvnnx4bs9l615bvn6mcq";
}

