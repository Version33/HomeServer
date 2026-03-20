{ ... }: {

  flake.modules.nixos.minecraft-plugin-purpur-extras = { pkgs, ... }:
    let
      purpurExtras = pkgs.fetchurl {
        url =
          "https://cdn.modrinth.com/data/Hn8OHmqL/versions/CDqR4k7K/PurpurExtras-1.36.0.jar";
        hash = "sha256-A/adHAzAzaJ/1MkcSVDB+7v1wHCh/HwVwfLsg1TvOGk=";
      };
    in {
      systemd.tmpfiles.rules = [
        "L+ /var/lib/minecraft/plugins/PurpurExtras-1.36.0.jar - - - - ${purpurExtras}"
      ];
    };

}
