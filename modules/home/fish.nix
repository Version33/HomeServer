{
  flake.modules.nixos.fish =
    { inputs, pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        package = inputs.nioxs.packages.${pkgs.stdenv.hostPlatform.system}.fish;
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
