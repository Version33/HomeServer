{

  flake.modules.nixos.caddy-core = _: {
    # Base Caddy configuration
    # Each service defines its own reverse proxy in its respective module
    services.caddy = {
      enable = true;
    };

    # Open public HTTP/HTTPS ports
    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
    };
  };

}
