{

  flake.modules.nixos.matter = _: {
    # Matter controller for HA (ws://localhost:5580/ws), localhost-only.
    services.matterjs-server = {
      enable = true;
      port = 5580;
    };

    services.home-assistant.extraComponents = [ "matter" ];
  };

}
