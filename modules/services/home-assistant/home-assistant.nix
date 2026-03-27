{

  flake.modules.nixos.home-assistant =
    { config, lib, ... }:
    {
      services.home-assistant = {
        enable = true;
        openFirewall = true;
        configWritable = true;
        extraComponents = [
          "met"
          "esphome"
          "zwave_js"
          "isal"
          "radio_browser"
          "zha"
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
