{
  flake.modules.nixos.jellyfin-media-cleaner =
    {
      pkgs,
      config,
      lib,
      ...
    }:

    let
      inherit (lib) mkIf;

      mediaCleanerPlugin = pkgs.stdenv.mkDerivation {
        name = "jellyfin-plugin-media-cleaner-3.2.0";
        src = pkgs.fetchurl {
          url = "https://github.com/shemanaev/jellyfin-plugin-media-cleaner/releases/download/v3.2.0/MediaCleaner-10.11.9.zip";
          hash = "sha256-Rz6TgtEsytoaY8JAWIx0EM5o+lfJAgx1EAS8H9ievrE=";
        };
        nativeBuildInputs = [ pkgs.unzip ];
        unpackPhase = "unzip $src";
        installPhase = ''
          mkdir -p "$out/Media Cleaner"
          cp -r * "$out/Media Cleaner/"
        '';
      };
    in
    {
      # Always install the Media Cleaner plugin when Jellyfin is enabled.
      # Configure rules via Jellyfin web UI: Dashboard > Plugins > Media Cleaner.
      config = mkIf config.services.jellyfin.enable {
        systemd.tmpfiles.rules = [
          "d /var/lib/jellyfin/plugins 0755 jellyfin jellyfin -"
          "L+ /var/lib/jellyfin/plugins/Media Cleaner - - - - ${mediaCleanerPlugin}/Media Cleaner"
        ];
      };
    };
}
