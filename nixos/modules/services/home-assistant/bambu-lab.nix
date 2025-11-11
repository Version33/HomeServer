{ config, pkgs, lib, ... }:

let
  bambuLab = pkgs.buildHomeAssistantComponent rec {
    owner = "greghesp";
    domain = "bambu_lab";
    version = "2.2.11";
    src = pkgs.fetchFromGitHub {
      owner = "greghesp";
      repo = "ha-bambulab";
      rev = "v${version}";
      hash = "sha256-Ypj9TdeRq6hzpIoQwhZtELsyuK+Ib4zMCxO3vWjDm3g=";
    };
    dependencies = with pkgs.home-assistant.python.pkgs; [
      beautifulsoup4
      paho-mqtt
    ];
  };
in { services.home-assistant.customComponents = [ bambuLab ]; }
