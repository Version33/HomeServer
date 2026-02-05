{ ... }: {

  flake.modules.nixos.nix-settings = _: {
    # ============================================================================
    # Nix Settings
    # ============================================================================
    nix.settings = {
      # Enable flakes and new nix command
      experimental-features = [ "nix-command" "flakes" ];

      # --------------------------------------------------------------------------
      # Performance & Storage Optimization
      # --------------------------------------------------------------------------
      auto-optimise-store = true; # Deduplicate identical files via hard links
      max-jobs = "auto"; # Use all available CPU cores for builds
      cores = 0; # Use all cores per build job (0 = all available)

      # --------------------------------------------------------------------------
      # Network & Download Settings
      # --------------------------------------------------------------------------
      http-connections =
        50; # Increase from default 25 for faster parallel downloads

      # Log download URLs to help debug slow fetches
      log-lines = 25;

      # --------------------------------------------------------------------------
      # Binary Caches (Substituters)
      # --------------------------------------------------------------------------
      substituters = [ "https://cache.nixos.org" ];

      trusted-public-keys =
        [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];

      # --------------------------------------------------------------------------
      # User Experience
      # --------------------------------------------------------------------------
      show-trace = true; # Show stack traces on evaluation errors
      warn-dirty = false; # Don't warn about dirty git trees during development

      # --------------------------------------------------------------------------
      # Security & Trust
      # --------------------------------------------------------------------------
      # Trust wheel group users for privileged operations
      trusted-users = [ "root" "@wheel" ];
    };
  };

}
