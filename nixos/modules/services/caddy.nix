{ config, pkgs, lib, ... }:

{
  services.caddy = {
    enable = true;

    virtualHosts = {
      # Public services with automatic HTTPS
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
          reverse_proxy http://localhost:8123
        '';
      };
    };

    extraConfig = ''
      :8096 {
        reverse_proxy http://localhost:8096
      }

      :5055 {
        reverse_proxy http://localhost:5055
      }

      :8123 {
        reverse_proxy http://localhost:8123
      }

      :7878 {
        reverse_proxy http://localhost:7878
      }

      :8989 {
        reverse_proxy http://localhost:8989
      }

      :9696 {
        reverse_proxy http://localhost:9696
      }

      :8080 {
        reverse_proxy http://localhost:8080
      }

      :9090 {
        reverse_proxy http://localhost:9090
      }
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    8096 # Jellyfin
    5055 # Jellyseerr
    8123 # Home Assistant
    7878 # Radarr
    8989 # Sonarr
    9696 # Prowlarr
    8080 # qBittorrent
    9090 # Cockpit
  ];
}
