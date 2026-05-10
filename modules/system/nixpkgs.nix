{

  flake.modules.nixos.nixpkgs = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };

}
