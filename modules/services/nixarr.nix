{

  flake.modules.nixos.nixarr = _: {
    # Nixarr configuration for *arr apps
    # Documentation: https://nixarr.com

    nixarr = {
      enable = true;

      # Media management directory structure
      # All media will be stored under /mnt/bigdisk/nixarr
      mediaDir = "/mnt/bigdisk/nixarr";

      # VPN configuration (optional - configure if you want to route traffic through VPN)
      # vpn = {
      #   enable = true;
      #   wgConf = "/path/to/wireguard.conf";
      # };

      # Jellyfin - Media Server
      jellyfin = {
        enable = true;
      };

      # Radarr - Movie management
      radarr = {
        enable = true;
      };

      # Sonarr - TV show management
      sonarr = {
        enable = true;
      };

      # Prowlarr - Indexer management
      prowlarr = {
        enable = true;
      };

      # Jellyseerr - Request management for Jellyfin
      jellyseerr = {
        enable = true;
      };

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

    # Fix permissions for Sonarr/Radarr to write to library directories
    # systemd.services.sonarr.serviceConfig.UMask = "0002";

    # systemd.services.radarr.serviceConfig.UMask = "0002";

    # Add jellyfin user to video group for hardware acceleration
    systemd.services.jellyfin.serviceConfig.SupplementaryGroups = [ "video" ];

    # Fix existing directory permissions to use media group
    systemd.tmpfiles.rules = [
      "d /mnt/bigdisk/nixarr 2775 root media - -"
      "Z /mnt/bigdisk/nixarr 2775 root media - -"
      "d /mnt/bigdisk/qbittorrent 2775 root media - -"
      "Z /mnt/bigdisk/qbittorrent 2775 root media - -"
    ];

    # Caddy reverse proxy configuration
    services.caddy.virtualHosts = {
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
    };

    # Firewall configuration for local network access
    networking.firewall.interfaces."enp0s31f6".allowedTCPPorts = [
      8096 # Jellyfin
      5055 # Jellyseerr
      7878 # Radarr
      8989 # Sonarr
      9696 # Prowlarr
    ];
  };

}
