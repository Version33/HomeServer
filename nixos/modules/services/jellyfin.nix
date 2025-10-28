{ config, pkgs, lib, ... }:

{
  # Jellyfin - Media Server
  services.jellyfin = {
    enable = true;
    # Jellyfin runs on port 8096 by default
    openFirewall = true;
  };

  # Ensure the jellyfin user has access to media directories
  # The media group is created by nixarr
  users.users.jellyfin.extraGroups = [ "media" ];
}
