{ ... }: {

  flake.modules.nixos.networking = _: {
    # Hostname
    networking.hostName = "homeserver";

    # Use systemd-networkd for network management
    networking.useNetworkd = true;
    networking.useDHCP = false;

    # Enable nftables firewall
    networking.nftables.enable = true;

    # Firewall configuration
    networking.firewall = {
      enable = true;
      # SSH and Caddy web server ports
      allowedTCPPorts = [ 22 80 443 ];
    };

    # Network configuration for main interface
    systemd.network = {
      enable = true;
      networks."10-wan" = {
        matchConfig.Name = "enp*";
        networkConfig = { DHCP = "yes"; };
      };
    };
  };

}
