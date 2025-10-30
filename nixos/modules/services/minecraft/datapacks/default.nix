{ config, pkgs, lib, ... }:

let
in {
  environment.etc."minecraft/allowed_symlinks.txt".text = ''
    /nix/store
  '';

  systemd.tmpfiles.rules = [
    "L+ /var/lib/minecraft/allowed_symlinks.txt - - - - /etc/minecraft/allowed_symlinks.txt"
  ];
}
