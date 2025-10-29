{ config, pkgs, lib, ... }:

{
  services.caddy = {
    enable = true;

    virtualHosts = {
      "jellyfin.versionthirtythr.ee" = {
        extraConfig = ''
          reverse_proxy http://localhost:8096
        '';
      };

      "seerr.versionthirtythr.ee" = {
        extraConfig = ''
          reverse_proxy http://localhost:5055
        '';
      };

      "hass.versionthirtythr.ee" = {
        extraConfig = ''
          reverse_proxy http://localhost:8123 {
            header_up X-Forwarded-Proto {scheme}
            header_up X-Forwarded-Host {host}
          }
        '';
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];

    interfaces = {
      "enp0s31f6".allowedTCPPorts = [
        8096 # Jellyfin
        5055 # Jellyseerr
        8123 # Home Assistant
        7878 # Radarr
        8989 # Sonarr
        9696 # Prowlarr
        8080 # qBittorrent
        8191 # FlareSolverr
        9090 # Cockpit
      ];
    };
  };
}
