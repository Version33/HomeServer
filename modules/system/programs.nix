{ ... }: {

  flake.modules.nixos.programs = _: {
    # Neovim configuration
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    # Terminal multiplexer
    programs.tmux = {
      enable = true;
      clock24 = true;
    };

    # Git configuration
    programs.git.enable = true;

    # System monitoring
    programs.htop.enable = true;
    programs.iotop.enable = true;
    programs.iftop.enable = true;
    programs.mtr.enable = true; # Network diagnostic tool
  };

}
