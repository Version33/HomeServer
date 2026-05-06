{

  flake.modules.nixos.minecraft-server =
    { inputs, pkgs, ... }:
    {
      imports = [ inputs.nix-minecraft.nixosModules.default ];

      nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

      services.minecraft-servers = {
        enable = true;
        eula = true;

        servers.survival = {
          enable = true;
          # Check available versions:
          # nix eval github:Infinidoge/nix-minecraft#packages.x86_64-linux --apply 'p: builtins.filter (n: builtins.match "neoforge.*1_21_1.*" n != null) (builtins.attrNames p)'
          package = pkgs.neoforgeServers.neoforge-1_21_1;

          jvmOpts = "-Xmx4G -Xms4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200";

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
        };
      };

      networking.firewall.interfaces."enp0s31f6".allowedTCPPorts = [ 25575 ];
    };

}
