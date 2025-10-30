{ config, pkgs, lib, ... }:

let
  tabtps = pkgs.fetchurl {
    url =
      "https://github.com/jpenilla/TabTPS/releases/download/v1.3.29/tabtps-paper-1.3.29.jar";
    sha256 = "fX47EMVBXwwqKXh+UNmD1Pb5tMwdAkRMkMXZhq9en5M=";
  };
in {
  systemd.tmpfiles.rules = [
    "L+ /var/lib/minecraft/plugins/tabtps-paper-1.3.29.jar - - - - ${tabtps}"
  ];
}
