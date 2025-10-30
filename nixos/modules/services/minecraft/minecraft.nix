{ config, pkgs, lib, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;

    package = pkgs.papermc;

    jvmOpts = "-Xmx4G -Xms4G";

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
