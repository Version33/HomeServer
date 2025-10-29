{ config, lib, ... }:

{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config.show_banner = false
    '';
    shellAliases = {
      mc-console = "mcrcon -H localhost -P 25575 -p changeme";
      mc-cmd = "mcrcon -H localhost -P 25575 -p changeme";
      mc-logs = "journalctl -u minecraft-server -f";
    };
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}
