{ config, pkgs, lib, ... }:

{
  services.wyoming.piper.servers.default = {
    enable = true;
    voice = "en_US-lessac-medium";
    uri = "tcp://0.0.0.0:10200";
  };

  services.wyoming.faster-whisper.servers.default = {
    enable = true;
    model = "base-int8";
    uri = "tcp://0.0.0.0:10300";
    language = "en";
  };

  networking.firewall.allowedTCPPorts = [ 10200 10300 ];
}
