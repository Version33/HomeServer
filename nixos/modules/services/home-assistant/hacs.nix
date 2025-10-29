{ config, pkgs, lib, ... }:

let
  hacs = pkgs.buildHomeAssistantComponent rec {
    owner = "hacs";
    domain = "hacs";
    version = "2.0.1";
    src = pkgs.fetchzip {
      url =
        "https://github.com/hacs/integration/releases/download/${version}/hacs.zip";
      hash = "sha256-eKTdksAKEU07y9pbHmTBl1d8L25eP/Y4VlYLubQRDmo=";
      stripRoot = false;
    };
    dependencies = with pkgs.home-assistant.python.pkgs; [ aiogithubapi ];
  };
in { services.home-assistant.customComponents = [ hacs ]; }
