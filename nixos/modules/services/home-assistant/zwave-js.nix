{ config, pkgs, lib, ... }:

{
  systemd.services.zwave-js-server = {
    description = "Z-Wave JS Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.zwave-js-server}/bin/zwave-server /dev/serial/by-id/usb-your-zwave-device --port 3000";
      Restart = "on-failure";
      User = "zwave";
      Group = "dialout";
      StateDirectory = "zwave-js";
      WorkingDirectory = "/var/lib/zwave-js";
    };
  };

  users.users.zwave = {
    isSystemUser = true;
    group = "dialout";
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
