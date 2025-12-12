{ config, pkgs, lib, ... }:

let
  hacs = pkgs.buildHomeAssistantComponent rec {
    owner = "hacs";
    domain = "hacs";
    version = "2.0.5";
    src = pkgs.fetchzip {
      url =
        "https://github.com/hacs/integration/releases/download/${version}/hacs.zip";
      hash = "sha256-iMomioxH7Iydy+bzJDbZxt6BX31UkCvqhXrxYFQV8Gw=";
      stripRoot = false;
    };
    dependencies = with pkgs.home-assistant.python.pkgs; [ aiogithubapi ];
  };
in { services.home-assistant.customComponents = [ hacs ]; }
