{ config, pkgs, lib, ... }:

{
  imports = [ ./tabtps.nix ./backuper.nix ./purpur-extras.nix ];
}
