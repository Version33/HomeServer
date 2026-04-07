{

  flake.modules.nixos.home-assistant =
    { config, lib, ... }:
    {
      services.home-assistant = {
        enable = true;
        openFirewall = true;
        extraComponents = [
          "met"
          "esphome"
          "zwave_js"
          "isal"
          "radio_browser"
          "mqtt"
          "sun"
          "mobile_app"
          "bluetooth"
          "lg_thinq"
        ];
        config = {
          default_config = { };
          http = {
            server_host = "0.0.0.0";
            server_port = 8123;
            trusted_proxies = [ "127.0.0.1" ];
            use_x_forwarded_for = true;
          };
          advanced = {
            channel = 11;
            pan_id = 6754;
            ext_pan_id = "00124b0030dd86a9";
            network_key = [
              1
              3
              5
              7
              9
              11
              13
              15
              0
              2
              4
              6
              8
              10
              12
              13
            ];
          };
        };
      };

      users.users.hass = lib.mkIf config.services.home-assistant.enable {
        extraGroups = [ "dialout" ];
      };

      services.caddy.virtualHosts = {
        "hass.versionthirtythr.ee" = {
          extraConfig = ''
            reverse_proxy http://localhost:8123
          '';
        };
      };
    };

}
