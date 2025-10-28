{ config, pkgs, lib, ... }:

{
  # Reverse proxy using Caddy
  services.caddy = {
    enable = true;

    # Global options to disable automatic HTTPS for local development
    globalConfig = ''
      auto_https off
    '';

    virtualHosts = {
      # Radarr - Movie management
      "http://radarr.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:7878
        '';
      };

      # Sonarr - TV show management
      "http://sonarr.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:8989
        '';
      };

      # Prowlarr - Indexer management
      "http://prowlarr.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:9696
        '';
      };

      # Jellyfin - Media server
      "http://jellyfin.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:8096
        '';
      };

      # Jellyseerr - Request management
      "http://jellyseerr.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:5055
        '';
      };

      # QBitTorrent - Torrent client
      "http://qbittorrent.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:8080
        '';
      };

      # Cockpit - System monitoring
      "http://cockpit.local" = {
        extraConfig = ''
          reverse_proxy http://localhost:9090
        '';
      };
    };
  };

  # Open firewall for Caddy
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
