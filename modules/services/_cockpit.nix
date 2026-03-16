{ ... }: {

  flake.modules.nixos.cockpit = { lib, ... }: {
    services.cockpit = {
      enable = true;
      port = 9090;
      settings = {
        WebService = {
          AllowUnencrypted = true;
          Origins = lib.mkForce
            "http://cockpit.local:8080 http://cockpit.local http://localhost:9090 http://192.168.1.83:9090";
        };
      };
    };

    # Firewall configuration for local network access
    networking.firewall.interfaces."enp0s31f6".allowedTCPPorts = [
      9090 # Cockpit Web UI
    ];
  };

}
