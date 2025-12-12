{ config, pkgs, lib, ... }:

let
  bambuLab = pkgs.buildHomeAssistantComponent rec {
    owner = "greghesp";
    domain = "bambu_lab";
    version = "2.2.17";
    src = pkgs.fetchzip {
      url =
        "https://github.com/greghesp/ha-bambulab/releases/download/v${version}/bambu_lab.zip";
      hash = "sha256-1HuKvnwVf7IcrfhlSGjRe2DhafxnCzf5P2caoSnHr7w=";
      stripRoot = false;
    };
    dependencies = with pkgs.home-assistant.python.pkgs; [
      beautifulsoup4
      paho-mqtt
    ];
  };
in { services.home-assistant.customComponents = [ bambuLab ]; }
