{ ... }: {

  flake.modules.nixos.minecraft-plugin-luckperms = { pkgs, ... }:
    let
      luckperms = pkgs.fetchurl {
        url =
          "https://download.luckperms.net/1606/bukkit/loader/LuckPerms-Bukkit-5.5.17.jar";
        sha256 = "sha256-1bFgo5cag3LMWDW81VXjfBqmHp3TBVmSGl9CGhG/l90=";
      };

      luckpermsConfig = pkgs.writeText "config.yml" ''
        server: homeserver
        storage-method: yaml
        data:
          pool-settings:
            maximum-pool-size: 10
            minimum-idle: 10
            maximum-lifetime: 1800000
            connection-timeout: 5000
      '';

      defaultGroupConfig = pkgs.writeText "default.yml" ''
        name: default
        displayname: everyone
        permissions:
        - tabtps.defaultdisplay:
          value: true
        - tabtps.tps:
          value: true
        - tabtps.toggle.actionbar:
            value: true
        - tabtps.toggle.bossbar:
            value: true
        - tabtps.toggle.tab:
            value: true
        - minecraft.command.seed:
            value: true
      '';
    in {
      systemd.tmpfiles.rules = [
        "L+ /var/lib/minecraft/plugins/LuckPerms-Bukkit-5.5.17.jar - - - - ${luckperms}"
        "d /var/lib/minecraft/plugins/LuckPerms 0755 minecraft minecraft - -"
        "L+ /var/lib/minecraft/plugins/LuckPerms/config.yml - - - - ${luckpermsConfig}"
        "d /var/lib/minecraft/plugins/LuckPerms/yaml-storage 0755 minecraft minecraft - -"
        "d /var/lib/minecraft/plugins/LuckPerms/yaml-storage/groups 0755 minecraft minecraft - -"
        "L+ /var/lib/minecraft/plugins/LuckPerms/yaml-storage/groups/default.yml - - - - ${defaultGroupConfig}"
      ];
    };

}
