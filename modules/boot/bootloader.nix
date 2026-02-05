{ ... }: {

  flake.modules.nixos.bootloader = { pkgs, ... }: {
    # Bootloader
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10; # Keep last 10 NixOS generations
        };
        efi = { canTouchEfiVariables = true; };
      };
      # Latest kernel for best hardware support
      kernelPackages = pkgs.linuxPackages_latest;
      # Required kernel modules for LVM and device mapper
      kernelModules = [ "dm-thin-pool" "dm-snapshot" "dm-mirror" ];
    };
  };

}
