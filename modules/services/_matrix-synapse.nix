{ ... }: {

  flake.modules.nixos.matrix-synapse = { pkgs, ... }: {
    services.matrix-synapse = {
      enable = true;

      settings = {
        server_name = "versionthirtythr.ee";
        public_baseurl = "https://matrix.versionthirtythr.ee";

        # Listener configuration
        listeners = [{
          port = 8008;
          bind_addresses = [ "127.0.0.1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [{
            names = [ "client" "federation" ];
            compress = false;
          }];
        }];

        # Database configuration (PostgreSQL)
        database = {
          name = "psycopg2";
          args = { database = "matrix-synapse"; };
        };

        # Disable registration by default
        enable_registration = false;
        enable_registration_without_verification = false;

        # URL previews
        url_preview_enabled = true;
        url_preview_ip_range_blacklist = [
          "127.0.0.0/8"
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "100.64.0.0/10"
          "169.254.0.0/16"
          "::1/128"
          "fe80::/64"
          "fc00::/7"
        ];

        # Media storage
        max_upload_size = "50M";

        # Enable metrics for monitoring (optional)
        enable_metrics = false;

        # Logging
        log_config = pkgs.writeText "log_config.yaml" ''
          version: 1
          formatters:
            precise:
              format: '%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(message)s'
          handlers:
            console:
              class: logging.StreamHandler
              formatter: precise
          loggers:
            synapse:
              level: INFO
          root:
            level: INFO
            handlers: [console]
        '';
      };

      # Additional settings
      extraConfigFiles = [ ];
    };

    # PostgreSQL database for Matrix
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "matrix-synapse" ];
      ensureUsers = [{
        name = "matrix-synapse";
        ensureDBOwnership = true;
      }];
    };

    # Firewall configuration - allow local access
    networking.firewall = {
      interfaces = {
        "enp0s31f6".allowedTCPPorts = [
          8008 # Matrix Synapse
        ];
      };
    };

    # Caddy reverse proxy configuration
    services.caddy.virtualHosts = {
      "matrix.versionthirtythr.ee" = {
        extraConfig = ''
          reverse_proxy /_matrix/* http://localhost:8008
          reverse_proxy /_synapse/client/* http://localhost:8008
        '';
      };

      "versionthirtythr.ee" = {
        extraConfig = ''
          # Matrix server delegation for federation
          @matrix path /.well-known/matrix/*
          header @matrix Content-Type application/json
          header @matrix Access-Control-Allow-Origin *
          respond /.well-known/matrix/server `{"m.server": "matrix.versionthirtythr.ee:443"}` 200
          respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"https://matrix.versionthirtythr.ee"}}` 200
        '';
      };
    };
  };

}
