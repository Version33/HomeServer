{ config, pkgs, lib, ... }:

{
  services.netdata = {
    enable = true;
    enableAnalyticsReporting = false;
    package = pkgs.netdata.override {
      withCloudUi = true;
    };
    config = {
      web = {
        "bind to" = "127.0.0.1:19999";
      };
    };
  };
}
