{

  flake.modules.nixos.fmd =
    { pkgs, ... }:
    {
      networking.firewall.interfaces."enp0s31f6".allowedTCPPorts = [
        8082 # FMD Server web UI / app registration
      ];

      services.caddy.virtualHosts = {
        "fmd.versionthirtythr.ee" = {
          extraConfig = ''
            reverse_proxy http://localhost:8082
          '';
        };
      };

      systemd.services.fmd-server = {
        description = "FMD Server - FindMyDevice location server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = "fmd-server";
          Group = "fmd-server";
          ExecStart = "${pkgs.fmd-server}/bin/fmd-server serve";
          Restart = "on-failure";
          RestartSec = "5s";

          StateDirectory = "fmd-server";
          WorkingDirectory = "/var/lib/fmd-server";

          Environment = [
            "FMD_DATABASEDIR=/var/lib/fmd-server"
            "FMD_PORTINSECURE=8082"
            "FMD_REMOTEIPHEADER=X-Forwarded-For"
          ];

          EnvironmentFile = "/etc/fmd-server/secrets.env";

          # Hardening
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ReadWritePaths = "/var/lib/fmd-server";
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          SystemCallArchitectures = "native";
        };
      };

      users.users.fmd-server = {
        isSystemUser = true;
        group = "fmd-server";
        home = "/var/lib/fmd-server";
        createHome = true;
      };

      users.groups.fmd-server = { };

      systemd.tmpfiles.rules = [
        "d /etc/fmd-server 0700 root root - -"
      ];
    };

}
