{ config, pkgs, lib, ... }:

let
  # Lovelace cards (frontend plugins)
  card-mod = pkgs.fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-card-mod";
    rev = "15b4f457a93ec9fde350d8be7864fa92dcfdfc31";
    hash = "sha256-Jkd+GNqCkR+2r6Uw5lAGPfUpK0+ZUMelJarRWSFTUVc=";
  };

  lovelace-layout-card = pkgs.fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-layout-card";
    rev = "b67162283d36e44390f3eba04254668aac3cc752";
    hash = "sha256-JIih1wAMk1g8AtHSFCHsOKKZUSRQDxjl7XVwtMnyehQ=";
  };

  hui-element = pkgs.fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-hui-element";
    rev = "1a805470152c86d9351abc7b0b56ef3ecb7e3a39";
    hash = "sha256-9/xdja3bkFOVbVvlQrtAl8kzPZ0jSMh2ur++k1NMqQY=";
  };

  button-card = pkgs.fetchFromGitHub {
    owner = "custom-cards";
    repo = "button-card";
    rev = "cee607b1007ca4511a0b989e698311fc105e3d3e";
    hash = "sha256-kgoqiFWO6EBWnnapEIsiujKyG47vh32OpRcenztV+TU=";
  };

  mushroom = pkgs.fetchFromGitHub {
    owner = "piitaya";
    repo = "lovelace-mushroom";
    rev = "c1cb869b25460e1d13e0a0f2ec81593e090d7417";
    hash = "sha256-qW4I1ajXxCzrhjO8YYI8RH0pMMbD0YXx71eelA/Xvnk=";
  };

  config-template-card = pkgs.fetchFromGitHub {
    owner = "iantrich";
    repo = "config-template-card";
    rev = "bcbc09b086cd4b9eb8847e73cfe5014668f3f777";
    hash = "sha256-ieFYorRpyfp6lC7XRvEyzL/2GWqGATi4Djq4h1FWNE4=";
  };

  custom-ui = pkgs.fetchFromGitHub {
    owner = "Mariusthvdb";
    repo = "custom-ui";
    rev = "3edc2c324db4b241c47e4a8dbd9492022e6deaef";
    hash = "sha256-Lo5BaY/lUcNdw1N74mtEHYCxhQfwCFWzw4rZaybi7Mc=";
  };

  tabbed-card = pkgs.fetchFromGitHub {
    owner = "kinghat";
    repo = "tabbed-card";
    rev = "41ce3d7ee4443b4d1d88d941ebd4cdc66f8375d5";
    hash = "sha256-bXlOLMiQOfVLSZcR6v9VZvzirlQStBilJh7SHNvdfhY=";
  };

  # FontAwesome integration (custom component, not a lovelace card)
  fontawesome = pkgs.buildHomeAssistantComponent rec {
    owner = "thomasloven";
    domain = "fontawesome";
    version = "2.2.0";
    src = pkgs.fetchFromGitHub {
      owner = "thomasloven";
      repo = "hass-fontawesome";
      rev = "98d628b7c64d07ef9ccde679faf1c6e490191484";
      hash = "sha256-9jNuBm4lJfv3oQENfEDnmo7x8tMEkhJU8QzwY5hPPxI=";
    };
  };

in {
  # Create www/community directory with correct ownership
  systemd.tmpfiles.rules = [
    "d ${config.services.home-assistant.configDir}/www 0755 hass hass -"
    "d ${config.services.home-assistant.configDir}/www/community 0755 hass hass -"
    "L+ ${config.services.home-assistant.configDir}/www/community/lovelace-card-mod - - - - ${card-mod}"
    "L+ ${config.services.home-assistant.configDir}/www/community/lovelace-layout-card - - - - ${lovelace-layout-card}"
    "L+ ${config.services.home-assistant.configDir}/www/community/lovelace-hui-element - - - - ${hui-element}"
    "L+ ${config.services.home-assistant.configDir}/www/community/button-card - - - - ${button-card}"
    "L+ ${config.services.home-assistant.configDir}/www/community/lovelace-mushroom - - - - ${mushroom}"
    "L+ ${config.services.home-assistant.configDir}/www/community/config-template-card - - - - ${config-template-card}"
    "L+ ${config.services.home-assistant.configDir}/www/community/custom-ui - - - - ${custom-ui}"
    "L+ ${config.services.home-assistant.configDir}/www/community/tabbed-card - - - - ${tabbed-card}"
  ];

  # FontAwesome is a custom component, not a lovelace card
  services.home-assistant.customComponents = [ fontawesome ];
}
