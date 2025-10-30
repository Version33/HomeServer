{
  description = "NixOS Home Server with native service integration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixarr.url = "github:rasmus-kirk/nixarr";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixarr, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # NixOS configuration
      nixosConfigurations = {
        # Main server configuration
        # To deploy: sudo nixos-rebuild switch --flake .#homeserver
        homeserver = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixarr.nixosModules.default
            home-manager.nixosModules.home-manager
            ./nixos/configuration.nix
          ];
        };
      };

      # Development shell with tools
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "homeserver-dev";

        buildInputs = with pkgs; [
          # Command runner
          just

          # Nix tools
          nixfmt-classic
          nil # Nix language server

          # Utilities
          git
          curl
          jq
        ];

        shellHook = ''
          echo "🏠 Home Server Development Environment"
          echo ""
          echo "Available commands:"
          echo "  just --list    # Show all available commands"
          echo "  just build     # Build the configuration"
          echo "  just deploy    # Deploy to the server"
          echo ""
        '';
      };
    };
}
