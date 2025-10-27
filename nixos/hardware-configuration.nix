# Hardware configuration placeholder
# Generate this for your actual hardware with:
#   nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  # Common kernel modules for most systems
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "nvme" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];  # Change to "kvm-amd" for AMD processors
  boot.extraModulePackages = [ ];

  # IMPORTANT: Update these filesystem mounts for your hardware!
  # You can find your disk IDs with: ls -l /dev/disk/by-uuid/
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";  # Update this!
    fsType = "ext4";
  };

  # Add swap if needed:
  # swapDevices = [
  #   { device = "/dev/disk/by-label/swap"; }
  # ];
  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
