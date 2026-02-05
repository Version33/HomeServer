{ ... }: {

  flake.modules.nixos.environment = { pkgs, ... }: {
    # System packages
    environment.systemPackages = with pkgs; [
      # Network utilities
      wget
      curl

      # Modern CLI tools
      kitty # xterm-kitty terminfo
      ripgrep # Fast grep
      fd # Fast find
      bat # Cat with syntax highlighting
      btop # Modern process viewer
      duf # Better df
      dust # Better du

      # File management
      tree
      ncdu # Disk usage analyzer

      # Compression
      unzip
      p7zip

      # Database tools
      sqlite

      # Media
      mpv
      yt-dlp
      ffmpeg
    ];

    # Shell aliases
    environment.shellAliases = { v = "nvim"; };
  };

}
