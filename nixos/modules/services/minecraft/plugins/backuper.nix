{ config, pkgs, lib, ... }:

let
  backuper = pkgs.fetchurl {
    url = "https://github.com/DVDishka/Backuper/releases/download/3.4.5/Backuper-3.4.5.jar";
    sha256 = "Zi5Tv5vbB1a7vrg3NsHax6UJb47dmvCJTPPnVSV366Y=";
  };
in {
  systemd.tmpfiles.rules = [
    "L+ /var/lib/minecraft/plugins/backuper.jar - - - - ${backuper}"
  ];
}
