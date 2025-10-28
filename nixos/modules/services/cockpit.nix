{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    settings = {
      WebService = {
        AllowUnencrypted = true;
        Origins = lib.mkForce "http://cockpit.local:8080 http://cockpit.local http://localhost:9090";
      };
    };
  };
}
