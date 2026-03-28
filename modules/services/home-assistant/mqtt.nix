{ ... }: {

  flake.modules.nixos.mqtt = { pkgs, ... }: {

    services = {
      zigbee2mqtt = {
        enable = true;
        settings = {
          mqtt = {
            base_topic = "zigbee2mqtt";
            server = "mqtt://localhost:1883";
          };
          serial = {
            port = "/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_922c6889026bef11baba99adc169b110-if00-port0";
            adapter = "zstack";
          };
          advanced = {
            channel = 11;
            network_key = "GENERATE";
            pan_id = "GENERATE";
            ext_pan_id = "GENERATE";
          };
          frontend.enabled = true;
          homeassistant.enabled = true;
        };
      };

      mosquitto = {
        enable = true;
        listeners = [
          {
            acl = [ "pattern readwrite #" ];
            omitPasswordAuth = true;
            settings.allow_anonymous = true;
          }
        ];
      };
    };
  };

}
