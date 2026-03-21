{

  flake.modules.nixos.continuwuity = _: {
    # Continuwuity - community-driven Matrix homeserver (Rust, fork of conduwuit/Conduit)
    # Documentation: https://continuwuity.org
    # After first deploy, register your admin user via any Matrix client, then set
    # allow_registration = false and remove registration_token_file.

    services.matrix-continuwuity = {
      enable = true;

      settings.global = {
        # Bind only on localhost; Caddy handles TLS termination
        address = [ "127.0.0.1" ];
        port = 6167;

        # The Matrix server_name that appears in user IDs: @user:versionthirtythr.ee
        server_name = "versionthirtythr.ee";

        # Set to true on first deploy to register the initial admin user,
        # then flip to false once your admin account is created.
        allow_registration = false;

        trusted_servers = [ "matrix.org" ];
      };
    };

    # Caddy reverse proxy - clients and federation both via versionthirtythr.ee
    services.caddy.virtualHosts = {
      "versionthirtythr.ee" = {
        extraConfig = ''
          reverse_proxy /_matrix/* http://localhost:6167
        '';
      };

      # Federation: remote servers connect on port 8448
      "versionthirtythr.ee:8448" = {
        extraConfig = ''
          reverse_proxy /_matrix/* http://localhost:6167
        '';
      };
    };

    networking.firewall.allowedTCPPorts = [
      8448 # Matrix federation
    ];

    # LAN direct access to the Continuwuity port (optional, for local clients)
    networking.firewall.interfaces."enp0s31f6".allowedTCPPorts = [
      6167 # Continuwuity internal port
    ];
  };

}
