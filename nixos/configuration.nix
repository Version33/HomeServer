{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/networking.nix
    ./modules/nixarr.nix
    ./modules/jellyfin.nix
    ./modules/qbittorrent.nix
    ./modules/caddy.nix
  ];

  # Boot configuration
  boot.loader.grub = {
    enable = true;
    device = lib.mkDefault "/dev/sda";  # Change for your hardware
  };

  # System hostname
  networking.hostName = "homeserver";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages
  environment.systemPackages = with pkgs; [
    # Network utilities
    wget
    curl

    # Modern CLI tools
    ripgrep  # Fast grep
    fd       # Fast find
    bat      # Cat with syntax highlighting
    btop     # Modern process viewer
    duf      # Better df
    dust     # Better du

    # File management
    tree
    ncdu     # Disk usage analyzer

    # Compression
    unzip
    p7zip
  ];

  # Shell configuration
  programs.nushell.enable = true;

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Terminal multiplexer
  programs.tmux = {
    enable = true;
    clock24 = true;
  };

  # Git configuration
  programs.git.enable = true;

  # System monitoring
  programs.htop.enable = true;
  programs.iotop.enable = true;
  programs.iftop.enable = true;
  programs.mtr.enable = true;  # Network diagnostic tool

  # Shell aliases
  environment.shellAliases = {
    v = "nvim";
  };

  # Enable SSH for remote management
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  # User configuration
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "media" ];
    shell = pkgs.nushell;
    # Set password with: passwd admin
    # Or use initialPassword for first boot
  };

  # Require password for sudo
  security.sudo.wheelNeedsPassword = true;

  # VM-specific configuration for testing
  # This section is only used when building with .vmVariant
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      diskSize = 20480;  # 20GB

      # Forward ports from host to VM
      forwardPorts = [
        { from = "host"; host.port = 8080; guest.port = 80; }     # Caddy HTTP
        { from = "host"; host.port = 8443; guest.port = 443; }    # Caddy HTTPS
        { from = "host"; host.port = 2222; guest.port = 22; }     # SSH
      ];
    };

    # VM-specific overrides for easier testing
    users.users.admin.initialPassword = "test";  # Easy password for VM testing
    security.sudo.wheelNeedsPassword = lib.mkForce false;  # No sudo password in VM
  };

  # NixOS version
  system.stateVersion = "24.05";
}
