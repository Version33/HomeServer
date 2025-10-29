{ config, pkgs, lib, ... }:

{
  # Proton VPN WireGuard Configuration
  #
  # This VPN is ONLY for qbittorrent traffic.
  # All other services use the regular internet connection.
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
      autostart = true;

      privateKeyFile = "/root/secrets/protonvpn-private.key";

      address = [ "10.2.0.2/32" ];

      dns = [ "10.2.0.1" ];

      table = "51820";

      peers = [{
        publicKey = "RAy+GOFz+bdG0l/wS+4J2AcpcVyUc2xbR6JR1Q8zJg4=";

        endpoint = "149.22.94.1:51820";

        allowedIPs = [ "0.0.0.0/0" ];

        persistentKeepalive = 25;
      }];

      postUp = ''
        ${pkgs.iproute2}/bin/ip rule add from 10.2.0.2 table 51820
        ${pkgs.iproute2}/bin/ip route add default dev protonvpn table 51820
      '';

      preDown = ''
        ${pkgs.iproute2}/bin/ip rule del from 10.2.0.2 table 51820 || true
      '';
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
