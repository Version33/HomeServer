{ config, pkgs, lib, ... }:

{
  # Nixarr configuration for *arr apps
  # Documentation: https://nixarr.com

  nixarr = {
    enable = true;

    # Media management directory structure
    # All media will be stored under /data
    mediaDir = "/mnt/bigdisk/nixarr";

    # VPN configuration (optional - configure if you want to route traffic through VPN)
    # vpn = {
    #   enable = true;
    #   wgConf = "/path/to/wireguard.conf";
    # };

    # Jellyfin - Media Server
    jellyfin = { enable = true; };

    # Radarr - Movie management
    radarr = { enable = true; };

    # Sonarr - TV show management
    sonarr = { enable = true; };

    # Prowlarr - Indexer management
    prowlarr = { enable = true; };

    # Jellyseerr - Request management for Jellyfin
    jellyseerr = { enable = true; };

    # lidarr = {
    #   enable = true;
    #   # Lidarr runs on port 8686 by default
    # };

    # readarr = {
    #   enable = true;
    #   # Readarr runs on port 8787 by default
    # };

    # bazarr = {
    #   enable = true;
    #   # Bazarr runs on port 6767 by default
    # };
  };
}
