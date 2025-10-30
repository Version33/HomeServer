{ config, pkgs, lib, ... }:

let
  tabtps = pkgs.fetchurl {
    url =
      "https://hangarcdn.papermc.io/plugins/jmp/TabTPS/versions/1.3.29/PAPER/tabtps-paper-1.3.29.jar";
    sha256 = "5ap38Up/M6SDTSUZK5LHpFKh7ic3hkCVsCF7AYGp3NA=";
  };
in {
  systemd.tmpfiles.rules = [
    "L+ /var/lib/minecraft/plugins/tabtps-paper-1.3.29.jar - - - - ${tabtps}"
  ];
}
