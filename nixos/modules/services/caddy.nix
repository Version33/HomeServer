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
      :8097 {
        reverse_proxy http://localhost:8096
      }

      :5056 {
        reverse_proxy http://localhost:5055
      }

      :8124 {
        reverse_proxy http://localhost:8123
      }

      :7879 {
        reverse_proxy http://localhost:7878
      }

      :8990 {
        reverse_proxy http://localhost:8989
      }

      :9697 {
        reverse_proxy http://localhost:9696
      }

      :8081 {
        reverse_proxy http://localhost:8080
      }

      :9091 {
        reverse_proxy http://localhost:9090
      }
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    8097 # Jellyfin
    5056 # Jellyseerr
    8124 # Home Assistant
    7879 # Radarr
    8990 # Sonarr
    9697 # Prowlarr
    8081 # qBittorrent
    9091 # Cockpit
  ];
}
