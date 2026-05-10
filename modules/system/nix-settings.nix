{

  flake.modules.nixos.nix-settings = _: {
    # ============================================================================
    # Nix Settings
    # ============================================================================
    nix.settings = {
      # Enable flakes and new nix command
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # --------------------------------------------------------------------------
      # Performance & Storage Optimization
      # --------------------------------------------------------------------------
      auto-optimise-store = true; # Deduplicate identical files via hard links
      max-jobs = "auto"; # Use all available CPU cores for builds
      cores = 0; # Use all cores per build job (0 = all available)

      # --------------------------------------------------------------------------
      # Network & Download Settings
      # --------------------------------------------------------------------------
      http-connections = 50; # Increase from default 25 for faster parallel downloads

      # Log download URLs to help debug slow fetches
      log-lines = 25;

      # --------------------------------------------------------------------------
      # Binary Caches (Substituters)
      # --------------------------------------------------------------------------
      # Using nix-community cache speeds up builds for packages like lanzaboote
      # Reference: https://nix.dev/guides/recipes/add-binary-cache
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # --------------------------------------------------------------------------
      # User Experience
      # --------------------------------------------------------------------------
      show-trace = true; # Show stack traces on evaluation errors
      warn-dirty = false; # Don't warn about dirty git trees during development

      # --------------------------------------------------------------------------
      # Security & Trust
      # --------------------------------------------------------------------------
      # Trust wheel group users for privileged operations
      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    # ============================================================================
    # Garbage Collection
    # ============================================================================
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    nix.optimise.automatic = true;
    nix.optimise.dates = [ "03:45" ];
  };

}
