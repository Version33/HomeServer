{ config, pkgs, lib, ... }:

{
  imports = [
    ./hacs.nix
    ./bambu-lab.nix
    ./bambu-lab-media.nix
    ./zwave-js.nix
    ./wyoming.nix
    ./lovelace-cards.nix
  ];

  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents =
      [ "esphome" "met" "radio_browser" "zwave_js" "wyoming" "zha" "lg_thinq" ];
    config = {
      default_config = { };
      automation = "!include automations.yaml";
      http = {
        server_host = "0.0.0.0";
        server_port = 8123;
        trusted_proxies = [ "127.0.0.1" ];
        use_x_forwarded_for = true;
      };

      lovelace = {
        mode = "yaml";
        resources = [
          { url = "/local/community/lovelace-card-mod/card-mod.js"; type = "module"; }
          { url = "/local/community/lovelace-layout-card/layout-card.js"; type = "module"; }
          { url = "/local/community/lovelace-hui-element/hui-element.js"; type = "module"; }
          { url = "/local/community/custom-ui/custom-ui.js"; type = "module"; }
          { url = "/local/community/lovelace-mushroom/mushroom.js"; type = "module"; }
          { url = "/local/community/button-card/button-card.js"; type = "module"; }
          { url = "/local/community/tabbed-card/tabbed-card.js"; type = "module"; }
          { url = "/local/community/config-template-card/config-template-card.js"; type = "module"; }
        ];
        dashboards = {
          "main-dashboard" = {
            mode = "yaml";
            title = "Home";
            icon = "mdi:home";
            show_in_sidebar = true;
            filename = "ui-lovelace.yaml";
          };
          "h2d-dashboard" = {
            mode = "yaml";
            title = "H2D";
            icon = "mdi:printer-3d";
            show_in_sidebar = true;
            filename = "ui-h2d.yaml";
          };
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "L+ ${config.services.home-assistant.configDir}/ui-lovelace.yaml - - - - ${./dashboards/ui-lovelace.yaml}"
    "L+ ${config.services.home-assistant.configDir}/ui-h2d.yaml - - - - ${./dashboards/ui-h2d.yaml}"
  ];

  users.users.hass = lib.mkIf config.services.home-assistant.enable {
    extraGroups = [ "dialout" ];
  };
}
