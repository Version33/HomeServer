{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/networking.nix
    ./modules/incus.nix
    ./modules/caddy.nix
    ./modules/containers.nix
  ];

  # Boot configuration
  boot.loader.grub = {
    enable = true;
    device = lib.mkDefault "/dev/vda";  # Use mkDefault so it can be overridden for real hardware
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
    git
  ];

  # Enable SSH for remote management
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = lib.mkDefault "yes";  # Disable this for production
  };

  # User configuration
  users.users.incus-admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "incus-admin" ];
    initialPassword = "changeme";  # Change this for production!
  };

  # Allow wheel group to use sudo without password
  # SECURITY: Disable this for production deployment
  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  # VM-specific configuration
  # This section is only used when building as a VM
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;

      # Forward ports from host to VM
      forwardPorts = [
        { from = "host"; host.port = 8080; guest.port = 80; }     # Caddy HTTP
        { from = "host"; host.port = 8443; guest.port = 443; }    # Caddy HTTPS
        { from = "host"; host.port = 9443; guest.port = 8443; }   # Incus UI
        { from = "host"; host.port = 2222; guest.port = 22; }     # SSH
      ];

      # Additional disk space for containers
      diskSize = 32768; # 32GB
    };
  };

  # NixOS version
  system.stateVersion = "24.05";
}
