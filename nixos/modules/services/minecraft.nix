{ config, pkgs, lib, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;

    package = let
      fixedPurpur = pkgs.purpur.overrideAttrs (oldAttrs: {
        installPhase = ''
                    runHook preInstall

                    mkdir -p $out/bin $out/lib/minecraft
                    cp -v $src $out/lib/minecraft/server.jar

                    cat > $out/bin/minecraft-server <<EOF
          #!/bin/sh
          exec ${pkgs.jdk}/bin/java "\$@" -jar $out/lib/minecraft/server.jar nogui
          EOF

                    chmod +x $out/bin/minecraft-server

                    runHook postInstall
        '';
      });
    in fixedPurpur;

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
