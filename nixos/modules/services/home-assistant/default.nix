{ config, pkgs, lib, ... }:

{
  imports = [
    ./hacs.nix
    ./bambu-lab.nix
    ./zwave-js.nix
    ./wyoming.nix
  ];

  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      "esphome"
      "met"
      "radio_browser"
      "zwave_js"
      "wyoming"
      "zha"
      "lg_thinq"
    ];
    config = {
      default_config = {};
      automation = "!include automations.yaml";
      http = {
        server_host = "127.0.0.1";
        server_port = 8123;
        trusted_proxies = [ "127.0.0.1" ];
        use_x_forwarded_for = true;
      };
    };
  };

  users.users.hass = lib.mkIf config.services.home-assistant.enable {
    extraGroups = [ "dialout" ];
  };
}
