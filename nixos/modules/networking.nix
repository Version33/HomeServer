{ config, pkgs, lib, ... }:

{
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
      # Incus web UI and Caddy
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
}
