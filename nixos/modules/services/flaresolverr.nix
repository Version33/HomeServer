{ config, pkgs, lib, ... }:

{
  systemd.services.flaresolverr = {
    description = "FlareSolverr - Proxy server to bypass Cloudflare protection";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = "flaresolverr";
      Group = "media";
      ExecStart = "${pkgs.flaresolverr}/bin/flaresolverr";
      Restart = "on-failure";
      RestartSec = "5s";

      Environment = [ "LOG_LEVEL=info" "PORT=8191" ];

      UMask = "0002";
    };
  };

  users.users.flaresolverr = {
    isSystemUser = true;
    group = "media";
    home = "/var/lib/flaresolverr";
    createHome = true;
  };
}
