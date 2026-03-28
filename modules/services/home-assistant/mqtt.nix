{ ... }: {

  flake.modules.nixos.mqtt = { pkgs, ... }: {

    services = {
      zigbee2mqtt = {
        enable = true;
          homeassistant.enabled = true;
          permit_join = true;
          serial = {
            port = "/dev/ttyACM1";
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

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 1883 ];
      };
    };
  };

}
