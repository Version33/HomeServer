{ config, pkgs, lib, ... }:

{
  # QBitTorrent - Torrent client with web UI
  services.qbittorrent = {
    enable = true;
    # Web UI runs on port 8080 by default
    openFirewall = true;

    # Run as a specific user
    user = "qbittorrent";
    group = "media"; # Use the media group created by nixarr
  };

  # Create qbittorrent user
  users.users.qbittorrent = {
    isSystemUser = true;
    group = "media";
    home = "/var/lib/qbittorrent";
    createHome = true;
  };

  # Allow Radarr and other *arr apps to access downloads
  # VPN killswitch: require VPN to be running
  systemd.services.qbittorrent = {
    requires = [ "wg-quick-protonvpn.service" ];
    after = [ "wg-quick-protonvpn.service" ];
    serviceConfig = {
      UMask = "0002";
    };
  };
}
