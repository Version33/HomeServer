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

      # Local-only services
      "http://radarr.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:7878
        '';
      };

      "http://sonarr.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:8989
        '';
      };

      "http://prowlarr.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:9696
        '';
      };

      "http://jellyfin.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:8096
        '';
      };

      "http://jellyseerr.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:5055
        '';
      };

      "http://qbittorrent.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:8080
        '';
      };

      "http://cockpit.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:9090
        '';
      };

      "http://homeassistant.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:8123
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
