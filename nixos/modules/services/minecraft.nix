{ config, pkgs, lib, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;

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

    dataDir = "/var/lib/minecraft";
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
}
