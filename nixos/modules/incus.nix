{ config, pkgs, lib, ... }:

{
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

  # System packages for Incus management
  environment.systemPackages = with pkgs; [
    incus
  ];
}
