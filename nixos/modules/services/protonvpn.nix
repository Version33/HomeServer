{ config, pkgs, lib, ... }:

{
  # Proton VPN WireGuard Configuration
  #
  # Setup steps:
  # 1. Get WireGuard config from Proton:
  #    - Log into https://account.protonvpn.com/
  #    - Go to Downloads -> WireGuard configuration
  #    - Download a config file for your preferred server
  # 2. Extract the values and fill them in below
  # 3. Enable this module in configuration.nix

  networking.wg-quick.interfaces = {
    protonvpn = {
      # Enable this interface
      autostart = true;

      # Your WireGuard private key from Proton config
      # Store this securely! Consider using agenix or sops-nix for secrets
      privateKeyFile = "/root/secrets/protonvpn-private.key";

      address = [
        # Your assigned IP addresses from Proton config
        # Example: "10.2.0.2/32"
        # Example: "fd7d:76ee:e68f:a993::2/128"
      ];

      dns = [ "10.2.0.1" ]; # Proton VPN DNS

      peers = [{
        # Proton VPN server public key from config
        publicKey = "YOUR_SERVER_PUBLIC_KEY_HERE";

        # Proton VPN endpoint (server:port)
        endpoint = "SERVER_IP_HERE:51820";

        # Route all traffic through VPN
        allowedIPs = [ "0.0.0.0/0" "::/0" ];

        # Keep connection alive
        persistentKeepalive = 25;
      }];
    };
  };

  # Bind qbittorrent to VPN interface (killswitch)
  systemd.services.qbittorrent = {
    requires = [ "wg-quick-protonvpn.service" ];
    after = [ "wg-quick-protonvpn.service" ];

    serviceConfig = {
      # Network namespace isolation - qbittorrent can ONLY use VPN
      PrivateNetwork = false;

      # Bind to VPN interface
      RestrictNetworkInterfaces = "protonvpn";
    };
  };

  # Optional: Add a script to check VPN and qbittorrent status
  environment.systemPackages = with pkgs; [
    wireguard-tools
    (pkgs.writeScriptBin "vpn-status" ''
      #!${pkgs.bash}/bin/bash
      echo "=== VPN Status ==="
      ${pkgs.wireguard-tools}/bin/wg show protonvpn
      echo ""
      echo "=== QBitTorrent IP (should be VPN IP) ==="
      ${pkgs.curl}/bin/curl -s --interface protonvpn https://icanhazip.com
      echo ""
      echo "=== QBitTorrent Service Status ==="
      ${pkgs.systemd}/bin/systemctl status qbittorrent --no-pager -l
    '')
  ];
}
