{ config, pkgs, lib, ... }:

{
  networking = {
    # Hostname is set in configuration.nix

    # Use systemd-networkd for network management
    useNetworkd = true;
    useDHCP = false;

    # Enable nftables firewall
    nftables.enable = true;

    # Firewall configuration
    firewall = {
      enable = true;
      # SSH and Caddy web server ports
      allowedTCPPorts = [ 22 80 443 ];
    };
  };

  # Network configuration for main interface
  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp*";
      networkConfig = { DHCP = "yes"; };
    };
  };
}
