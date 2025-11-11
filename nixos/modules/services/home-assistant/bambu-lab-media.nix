{ config, pkgs, lib, ... }:

let
  # Download and extract the Bambu Lab media files
  # Source: https://www.wolfwithsword.com/bambulab-home-assistant-dashboard/
  bambuMediaFiles = pkgs.stdenv.mkDerivation {
    name = "bambu-ha-media-files";
    version = "nightly";
    src = pkgs.fetchzip {
      url =
        "https://github.com/WolfwithSword/Bambu-HomeAssistant-Flows/releases/download/nightly/bambu-ha-media-files.zip";
      hash = "sha256-6EKSJ47zPjt5uLZ5fcwjs/wwv3pA90uSVNp5t+bwKgo=";
      stripRoot = false;
    };
    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };
in {
  # Link the media files into Home Assistant's config directory
  # www/media/bambuprinter/*.png - Printer images
  # custom_icons/*.svg - FontAwesome filament icons
  systemd.tmpfiles.rules = lib.mkIf config.services.home-assistant.enable [
    "L+ ${config.services.home-assistant.configDir}/www/media/bambuprinter - - - - ${bambuMediaFiles}/www/media/bambuprinter"
    "L+ ${config.services.home-assistant.configDir}/custom_icons - - - - ${bambuMediaFiles}/custom_icons"
  ];

  # Ensure www/media directory exists
  systemd.services.home-assistant.preStart = lib.mkAfter ''
    mkdir -p ${config.services.home-assistant.configDir}/www/media
  '';
}
