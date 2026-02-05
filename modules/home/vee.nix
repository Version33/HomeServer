{ inputs, ... }: {

  flake.modules.homeManager.vee = _: {
    home = {
      username = "vee";
      homeDirectory = "/home/vee";
      stateVersion = "25.05";
    };
  };

}
