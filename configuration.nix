{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./incus-containers.nix
  ];

  # Boot configuration for VM
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking
  networking = {
    hostName = "incus-server";

    # Use systemd-networkd for better container networking
    useNetworkd = true;
    useDHCP = false;

    # Enable nftables (required by Incus)
    nftables.enable = true;

    # Firewall configuration
    firewall = {
      enable = true;
      # Incus web UI
      allowedTCPPorts = [ 8443 80 443 ];
      # Allow traffic from containers
      trustedInterfaces = [ "incusbr0" ];
    };
  };

  # Network configuration for main interface
  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp*";
      networkConfig = {
        DHCP = "yes";
      };
    };
  };

  # Virtualization - Incus
  virtualisation.incus = {
    enable = true;

    # Use latest Incus (not LTS) for OCI/Docker support
    package = pkgs.incus;

    # Enable UI
    ui.enable = true;

    # Preseed configuration for initial setup
    preseed = {
      # Global configuration
      config = {
        # Enable remote access on all interfaces
        "core.https_address" = "[::]:8443";
      };

      networks = [
        {
          name = "incusbr0";
          type = "bridge";
          config = {
            "ipv4.address" = "10.0.100.1/24";
            "ipv4.nat" = "true";
            "ipv6.address" = "none";
          };
        }
      ];

      profiles = [
        {
          name = "default";
          devices = {
            eth0 = {
              name = "eth0";
              network = "incusbr0";
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              type = "disk";
            };
          };
        }
      ];

      storage_pools = [
        {
          name = "default";
          driver = "dir";
          config = {
            source = "/var/lib/incus/storage-pools/default";
          };
        }
      ];
    };
  };

  # Reverse proxy using Caddy
  services.caddy = {
    enable = true;

    # Global options to disable automatic HTTPS for local development
    globalConfig = ''
      auto_https off
    '';

    virtualHosts = {
      # Incus web UI (HTTPS)
      "https://incus.local" = {
        extraConfig = ''
          reverse_proxy https://localhost:8443 {
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
      };

      # Radarr (HTTP only)
      "http://radarr.local" = {
        extraConfig = ''
          reverse_proxy http://10.0.100.11:7878
        '';
      };

      # Jellyfin (HTTP only)
      "http://jellyfin.local" = {
        extraConfig = ''
          reverse_proxy http://10.0.100.12:8096
        '';
      };

      # QBitTorrent (HTTP only)
      "http://qbittorrent.local" = {
        extraConfig = ''
          reverse_proxy http://10.0.100.13:8080
        '';
      };
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
    incus
  ];

  # Enable SSH for remote management
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # User configuration
  users.users.incus-admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "incus-admin" ];
    initialPassword = "changeme";
  };

  # Allow wheel group to use sudo
  security.sudo.wheelNeedsPassword = false;

  # Minimal VM configuration
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

  system.stateVersion = "24.05";
}
