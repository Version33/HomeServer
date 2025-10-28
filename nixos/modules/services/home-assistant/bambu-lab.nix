{ config, pkgs, lib, ... }:

let
  bambuLab = pkgs.buildHomeAssistantComponent rec {
    owner = "greghesp";
    domain = "bambu_lab";
    version = "2.2.9";
    src = pkgs.fetchFromGitHub {
      owner = "greghesp";
      repo = "ha-bambulab";
      rev = "v${version}";
      hash = "sha256-DJsIB5wFEGF6myTfHblJzIvS+zhGNLbB5j7zSrodP6s=";
    };
    dependencies = with pkgs.home-assistant.python.pkgs; [
      beautifulsoup4
      paho-mqtt
    ];
  };
in
{
  services.home-assistant.customComponents = [ bambuLab ];
}
