{ inputs, self, ... }: {
  # Import flake-parts modules and tools
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.flake-file.flakeModules.default
    inputs.treefmt-nix.flakeModule
  ];

  # Configure flake-file
  flake-file.outputs = "inputs: import ./. inputs";

  # Define core flake inputs here
  flake-file.inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Core system packages
    home-manager.url =
      "github:nix-community/home-manager"; # User environment manager
    flake-parts.url =
      "github:hercules-ci/flake-parts"; # Module system for flakes
    import-tree.url = "github:vic/import-tree"; # Automatic module discovery

    # Media server suite
    nixarr.url = "github:rasmus-kirk/nixarr";

    # Boilerplate reduction tools
    flake-file.url = "github:vic/flake-file"; # Generates flake.nix from modules
    treefmt-nix.url = "github:numtide/treefmt-nix"; # Project-wide formatting
  };

  # System architectures this flake supports
  systems = [ "x86_64-linux" ];

  # NixOS system configurations
  flake.nixosConfigurations = {
    homeserver = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs self; };
      modules = [
        ../hardware-configuration.nix

        # nixarr media suite
        inputs.nixarr.nixosModules.default

        # Home Manager integration
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          # Load all dendritic home-manager modules
          home-manager.sharedModules =
            builtins.attrValues (self.modules.homeManager or { });
        }
      ]
      # Load all dendritic NixOS modules
        ++ (builtins.attrValues self.modules.nixos);
    };
  };

  # Development environment & formatting
  perSystem = { pkgs, ... }: {
    # Configure treefmt
    treefmt = {
      projectRootFile = "flake.nix";
      programs.nixfmt.enable = true;
      programs.nixfmt.package = pkgs.nixfmt-classic;
    };

    # Development Shell
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        # Nix development tools
        nil # Nix language server
        nixfmt-classic # Nix formatter
        statix # Lints and suggestions for Nix code
        deadnix # Find and remove unused code
        nix-tree # Visualize dependency tree
        nix-output-monitor # Better build output (alias: nom)

        # Useful utilities
        git
        just # Command runner (for justfile)
        curl
        jq
      ];
    };
  };
}
