{ ... }:
{

  flake.modules.nixos.matrix-conduit = _: {
    services.matrix-conduit = {
      enable = true;

      # Contains: CONDUIT_REGISTRATION_TOKEN=<your-token>
      # Create this file on the server before enabling the service.
      secretFile = "/etc/secrets/matrix-conduit";

      settings.global = {
        server_name = "versionthirtythr.ee";
        address = "127.0.0.1";
        port = 6167;
        database_backend = "rocksdb";
        allow_registration = true;
        trusted_servers = [ "matrix.org" ];
        max_request_size = 52428800; # 50 MB in bytes
      };
    };

    services.caddy.virtualHosts."matrix.versionthirtythr.ee" = {
      extraConfig = ''
        reverse_proxy /_matrix/* http://127.0.0.1:6167
        reverse_proxy /_synapse/client/* http://127.0.0.1:6167

        handle /.well-known/matrix/server {
          respond `{"m.server":"matrix.versionthirtythr.ee:443"}` 200
        }

        handle /.well-known/matrix/client {
          respond `{"m.homeserver":{"base_url":"https://matrix.versionthirtythr.ee"}}` 200
          header Access-Control-Allow-Origin "*"
        }
      '';
    };

    # Federation port — must be publicly reachable
    networking.firewall.allowedTCPPorts = [ 8448 ];
  };

}
