{ config, pkgs, lib, ... }:

let
  luckperms = pkgs.fetchurl {
    url =
      "https://download.luckperms.net/1606/bukkit/loader/LuckPerms-Bukkit-5.5.17.jar";
    sha256 = "sha256-1bFgo5cag3LMWDW81VXjfBqmHp3TBVmSGl9CGhG/l90=";
  };
in {
  systemd.tmpfiles.rules = [
    "L+ /var/lib/minecraft/plugins/LuckPerms-Bukkit-5.5.17.jar - - - - ${luckperms}"
  ];
}
