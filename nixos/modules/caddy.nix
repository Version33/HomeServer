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
      # Incus web UI (HTTPS)
      "https://incus.local" = {
        extraConfig = ''
          reverse_proxy https://localhost:8443 {
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
      };

      # Radarr (HTTP only)
      "http://radarr.local" = {
        extraConfig = ''
          reverse_proxy http://10.0.100.11:7878
        '';
      };

      # Jellyfin (HTTP only)
      "http://jellyfin.local" = {
        extraConfig = ''
          reverse_proxy http://10.0.100.12:8096
        '';
      };

      # QBitTorrent (HTTP only)
      "http://qbittorrent.local" = {
        extraConfig = ''
          reverse_proxy http://10.0.100.13:8080
        '';
      };
    };
  };
}
