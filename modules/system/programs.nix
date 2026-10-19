{

  flake.modules.nixos.programs = { pkgs, ... }: {
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
    # iotop-c: the Python iotop is a script, which the setuid-wrapper
    # integrity check (ensure-wrapper-integrity) rejects as non-ELF.
    programs.iotop = {
      enable = true;
      package = pkgs.iotop-c;
    };
    programs.iftop.enable = true;
    programs.mtr.enable = true; # Network diagnostic tool
  };

}
