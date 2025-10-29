{ config, pkgs, lib, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    package = pkgs.purpur;

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

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    interfaces."enp0s31f6".allowedTCPPorts = [ 25575 ];
  };

  environment.shellAliases = {
    mc-console = "mcrcon -H localhost -P 25575 -p changeme";
    mc-cmd = "mcrcon -H localhost -P 25575 -p changeme";
    mc-logs = "journalctl -u minecraft-server -f";
  };
}
