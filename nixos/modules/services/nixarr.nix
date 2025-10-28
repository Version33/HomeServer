{ config, pkgs, lib, ... }:

{
  # Nixarr configuration for *arr apps
  # Documentation: https://nixarr.com

  nixarr = {
    enable = true;

    # Media management directory structure
    # All media will be stored under /data
    mediaDir = "/data/media";

    # VPN configuration (optional - configure if you want to route traffic through VPN)
    # vpn = {
    #   enable = true;
    #   wgConf = "/path/to/wireguard.conf";
    # };

    # Radarr - Movie management
    radarr = {
      enable = true;
      # Radarr runs on port 7878 by default
    };

    # Optional: Enable other *arr apps as needed
    # sonarr = {
    #   enable = true;
    #   # Sonarr runs on port 8989 by default
    # };

    # prowlarr = {
    #   enable = true;
    #   # Prowlarr runs on port 9696 by default
    # };

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
