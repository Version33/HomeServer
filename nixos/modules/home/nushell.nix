{ config, lib, ... }:

{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config.show_banner = false
    '';
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}
