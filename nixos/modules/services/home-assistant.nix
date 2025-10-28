{ config, pkgs, lib, ... }:

{
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      "esphome"
      "met"
      "radio_browser"
    ];
    config = {
      default_config = {};
      http = {
        server_host = "127.0.0.1";
        server_port = 8123;
        trusted_proxies = [ "127.0.0.1" ];
        use_x_forwarded_for = true;
      };
    };
  };
}
