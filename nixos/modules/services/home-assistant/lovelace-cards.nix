{ config, pkgs, lib, ... }:

let
  # Lovelace cards (frontend plugins)
  # Cards with pre-built JS in their GitHub repos
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

  custom-ui = pkgs.fetchFromGitHub {
    owner = "Mariusthvdb";
    repo = "custom-ui";
    rev = "3edc2c324db4b241c47e4a8dbd9492022e6deaef";
    hash = "sha256-Lo5BaY/lUcNdw1N74mtEHYCxhQfwCFWzw4rZaybi7Mc=";
  };

  # Cards with pre-built JS files as release assets
  # Download the JS file and create a directory structure
  mushroom = pkgs.runCommand "mushroom" {
    js = pkgs.fetchurl {
      url = "https://github.com/piitaya/lovelace-mushroom/releases/download/v5.0.8/mushroom.js";
      hash = "sha256-Amnr9UlsYlZ5i41yfXd8XwnEtnLJCxi2/mZ3xfJPCHk=";
    };
  } ''
    mkdir -p $out
    cp $js $out/mushroom.js
  '';

  button-card = pkgs.runCommand "button-card" {
    js = pkgs.fetchurl {
      url = "https://github.com/custom-cards/button-card/releases/download/v7.0.1/button-card.js";
      hash = "sha256-XW6cavygHoAUZT+la7XWqpJI2DLDT7lEp/LDYym8ItE=";
    };
  } ''
    mkdir -p $out
    cp $js $out/button-card.js
  '';

  tabbed-card = pkgs.runCommand "tabbed-card" {
    js = pkgs.fetchurl {
      url = "https://github.com/kinghat/tabbed-card/releases/download/v0.3.3/tabbed-card.js";
      hash = "sha256-bq1fmXdAtrTxYtJoMqSypvvLwFB7jpRw8PaiUa6OkBo=";
    };
  } ''
    mkdir -p $out
    cp $js $out/tabbed-card.js
  '';

  config-template-card = pkgs.runCommand "config-template-card" {
    js = pkgs.fetchurl {
      url = "https://github.com/iantrich/config-template-card/releases/download/1.3.6/config-template-card.js";
      hash = "sha256-7O48fgoQkg6aQy3i5/H5UGrnQkJelXQdGDW71N6lbC4=";
    };
  } ''
    mkdir -p $out
    cp $js $out/config-template-card.js
  '';

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
  # Use Z flag to recursively fix ownership and permissions
  systemd.tmpfiles.rules = [
    "d ${config.services.home-assistant.configDir}/www 0755 hass hass -"
    "Z ${config.services.home-assistant.configDir}/www 0755 hass hass -"
    "d ${config.services.home-assistant.configDir}/www/community 0755 hass hass -"
    "L+ ${config.services.home-assistant.configDir}/www/community/lovelace-card-mod - - - - ${card-mod}"
    "L+ ${config.services.home-assistant.configDir}/www/community/lovelace-layout-card - - - - ${lovelace-layout-card}"
    "L+ ${config.services.home-assistant.configDir}/www/community/lovelace-hui-element - - - - ${hui-element}"
    "L+ ${config.services.home-assistant.configDir}/www/community/custom-ui - - - - ${custom-ui}"
    "L+ ${config.services.home-assistant.configDir}/www/community/lovelace-mushroom - - - - ${mushroom}"
    "L+ ${config.services.home-assistant.configDir}/www/community/button-card - - - - ${button-card}"
    "L+ ${config.services.home-assistant.configDir}/www/community/tabbed-card - - - - ${tabbed-card}"
    "L+ ${config.services.home-assistant.configDir}/www/community/config-template-card - - - - ${config-template-card}"
  ];

  # FontAwesome is a custom component, not a lovelace card
  services.home-assistant.customComponents = [ fontawesome ];
}
