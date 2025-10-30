{ config, pkgs, lib, ... }:

let
  luckperms = pkgs.fetchurl {
    url =
      "https://download.luckperms.net/1606/bukkit/loader/LuckPerms-Bukkit-5.5.17.jar";
    sha256 = "sha256-1bFgo5cag3LMWDW81VXjfBqmHp3TBVmSGl9CGhG/l90=";
  };

  luckpermsConfig = pkgs.writeText "config.yml" ''
    server: homeserver
    storage-method: h2
    data:
      table-prefix: luckperms_
  '';

  defaultGroupConfig = pkgs.writeText "default.json" (builtins.toJSON {
    name = "default";
    displayName = "everyone";
    permissions = [
      {
        permission = "tabtps.toggle.tab";
        value = true;
      }
      {
        permission = "tabtps.toggle.actionbar";
        value = true;
      }
      {
        permission = "tabtps.toggle.bossbar";
        value = true;
      }
      {
        permission = "tabtps.defaultdisplay";
        value = true;
      }
    ];
  });
in {
  systemd.tmpfiles.rules = [
    "L+ /var/lib/minecraft/plugins/LuckPerms-Bukkit-5.5.17.jar - - - - ${luckperms}"
    "d /var/lib/minecraft/plugins/LuckPerms 0755 minecraft minecraft - -"
    "L+ /var/lib/minecraft/plugins/LuckPerms/config.yml - - - - ${luckpermsConfig}"
    "d /var/lib/minecraft/plugins/LuckPerms/yaml-storage 0755 minecraft minecraft - -"
    "d /var/lib/minecraft/plugins/LuckPerms/yaml-storage/groups 0755 minecraft minecraft - -"
    "L+ /var/lib/minecraft/plugins/LuckPerms/yaml-storage/groups/default.json - - - - ${defaultGroupConfig}"
  ];
}
