{ config, pkgs, lib, ... }:

let
  tabtps = pkgs.fetchurl {
    url = "https://github.com/jpenilla/TabTPS";
    sha256 = "5ap38Up/M6SDTSUZK5LHpFKh7ic3hkCVsCF7AYGp3NA=";
  };
in {
  systemd.tmpfiles.rules = [
    "L+ /var/lib/minecraft/plugins/tabtps-paper-1.3.29.jar - - - - ${tabtps}"
  ];
}
