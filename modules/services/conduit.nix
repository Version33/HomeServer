{

  flake.modules.nixos.conduit = _: {
    # Matrix Conduit - lightweight Matrix homeserver
    # Documentation: https://docs.conduit.rs
    # After first deploy, register your admin user, then set
    # allow_registration = false and remove registration_token.

    services.matrix-conduit = {
      enable = true;

      settings.global = {
        # Bind only on localhost; Caddy handles TLS termination
        address = "127.0.0.1";
        port = 6167;

        # The Matrix server_name that appears in user IDs: @user:versionthirtythr.ee
        server_name = "versionthirtythr.ee";

        # rocksdb is recommended over sqlite for long-term storage efficiency
        database_backend = "rocksdb";

        # Set to true on first deploy to register the initial admin user,
        # then flip to false once your admin account is created.
        allow_registration = false;

        trusted_servers = [ "matrix.org" ];
      };

      # Contains: CONDUIT_REGISTRATION_TOKEN=<your-token>
      # Create this file on the server before enabling the service.
      secretFile = "/etc/secrets/matrix-conduit";
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

    # LAN direct access to the Conduit port (optional, for local clients)
    networking.firewall.interfaces."enp0s31f6".allowedTCPPorts = [
      6167 # Conduit internal port
    ];
  };

}
