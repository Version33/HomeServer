{ config, pkgs, lib, ... }:

let
  backuper = pkgs.fetchurl {
    url = "https://github.com/DVDishka/Backuper";
    sha256 = "";
  };
in {
  systemd.tmpfiles.rules = [
    "L+ /var/lib/minecraft/plugins/backuper.jar - - - - ${backuper}"
  ];
}
