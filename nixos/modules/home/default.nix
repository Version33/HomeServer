{ config, pkgs, ... }:

{
  imports = [ ./nushell.nix ];

  home.stateVersion = "25.05";
}
