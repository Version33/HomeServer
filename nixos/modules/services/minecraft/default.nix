{ config, pkgs, lib, ... }:

{
  imports = [ ./server.nix ./tools.nix ./plugins ];
}
