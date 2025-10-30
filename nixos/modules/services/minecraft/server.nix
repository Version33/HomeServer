{ config, pkgs, lib, ... }:

let
  purpur = pkgs.papermc.overrideAttrs (old: rec {
    pname = "purpur";
    version = "1.21.10-2518";
    src = pkgs.fetchurl {
      url = "https://api.purpurmc.org/v2/purpur/1.21.10/2518/download";
      hash = "sha256-7hFHeENdv+wCixzxIKSiv6uo5YNWTS4i9951kTWyVvo=";
    };
  });
in {
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;

    package = purpur;

    jvmOpts = "-Xmx4G -Xms4G -Dpaper.disableWorldSymlinkValidation=true";

    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      difficulty = "normal";
      max-players = 20;
      motd = "NixOS Minecraft Server";
      white-list = false;
      enable-rcon = true;
      "rcon.port" = 25575;
      "rcon.password" = "changeme";
    };

    openFirewall = true;
  };

  networking.firewall.interfaces."enp0s31f6".allowedTCPPorts = [ 25575 ];
}
