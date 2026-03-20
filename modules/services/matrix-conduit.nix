{

  flake.modules.nixos.matrix-conduit = {
    services.matrix-conduit = {
      enable = true;

      # Contains: CONDUIT_REGISTRATION_TOKEN=<your-token>
      # Create this file on the server before enabling the service.
      secretFile = "/etc/secrets/matrix-conduit";

      settings.global = {
        server_name = "versionthirtythr.ee";

        # Bind only to localhost; Caddy handles TLS termination
        address = "127.0.0.1";
        port = 6167;

        # RocksDB is the recommended backend; no external database required
        database_backend = "rocksdb";

        # Max upload size (50 MiB in bytes)
        max_request_size = 52428800;

        allow_registration = true;

        allow_federation = true;
        allow_encryption = true;
        allow_room_creation = true;

        trusted_servers = [ "matrix.org" ];

        # Disable the ⚡️ suffix added to display names on registration
        enable_lightning_bolt = false;

        # Conduit serves /.well-known/matrix/* delegation responses itself.
        # Caddy must proxy those paths to Conduit (see virtualHosts below).
        well_known = {
          client = "https://matrix.versionthirtythr.ee";
          server = "matrix.versionthirtythr.ee:443";
        };
      };
    };

    # Caddy reverse proxy configuration
    services.caddy.virtualHosts = {
      "matrix.versionthirtythr.ee" = {
        extraConfig = ''
          reverse_proxy /_matrix/* http://localhost:6167
          reverse_proxy /_synapse/client/* http://localhost:6167
        '';
      };

      # Serve Matrix delegation from the root domain via Conduit
      "versionthirtythr.ee" = {
        extraConfig = ''
          reverse_proxy /.well-known/matrix/* http://localhost:6167
        '';
      };
    };
  };

}
