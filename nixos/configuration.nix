{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/networking.nix
    ./modules/services/nixarr.nix
    ./modules/services/qbittorrent.nix
    ./modules/services/vpn.nix
    ./modules/services/caddy.nix
    ./modules/services/cockpit.nix
    ./modules/services/flaresolverr.nix
    ./modules/services/home-assistant
  ];

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "dm-thin-pool" "dm-snapshot" "dm-mirror" ];

  # System hostname
  networking.hostName = "homeserver";

  fileSystems."/mnt/bigdisk" = {
    device = "/dev/disk/by-uuid/c0957a15-b3f4-4b06-9f3a-cc26619518f3";
    fsType = "ext4";
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Network utilities
    wget
    curl

    # Modern CLI tools
    ripgrep # Fast grep
    fd # Fast find
    bat # Cat with syntax highlighting
    btop # Modern process viewer
    duf # Better df
    dust # Better du

    # File management
    tree
    ncdu # Disk usage analyzer

    # Compression
    unzip
    p7zip

    # Database tools
    sqlite
  ];

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
  programs.mtr.enable = true; # Network diagnostic tool

  # Shell aliases
  environment.shellAliases = { v = "nvim"; };

  # Enable SSH for remote management
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  # User configuration
  users.users.vee = {
    isNormalUser = true;
    extraGroups = [ "wheel" "media" ];
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINfIKVYa5elcDEfmyfn+ODALz1Sy+OcajNskRxahTFOpAAAABHNzaDo= vee@homeserver"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINvec5l0CVyepm8MyoLJ0xrl5nJqztj7eul7HYsVV9zc vee@k0or"
    ];
  };

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.vee = import ./modules/home;
  };

  # Require password for sudo
  security.sudo.wheelNeedsPassword = true;

  # VM-specific configuration for testing
  # This section is only used when building with .vmVariant
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      diskSize = 20480; # 20GB

      # Forward ports from host to VM
      forwardPorts = [
        {
          from = "host";
          host.port = 8080;
          guest.port = 80;
        } # Caddy HTTP
        {
          from = "host";
          host.port = 8443;
          guest.port = 443;
        } # Caddy HTTPS
        {
          from = "host";
          host.port = 2222;
          guest.port = 22;
        } # SSH
      ];
    };

    # VM-specific overrides for easier testing
    users.users.vee.initialPassword = "test"; # Easy password for VM testing
    security.sudo.wheelNeedsPassword =
      lib.mkForce false; # No sudo password in VM
  };

  # NixOS version
  system.stateVersion = "25.05";
}
