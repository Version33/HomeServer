{ ... }: {

  flake.modules.nixos.minecraft-datapacks = _: {
    environment.etc."minecraft/allowed_symlinks.txt".text = ''
      /nix/store
    '';

    systemd.tmpfiles.rules = [
      "L+ /var/lib/minecraft/allowed_symlinks.txt - - - - /etc/minecraft/allowed_symlinks.txt"
    ];
  };

}
