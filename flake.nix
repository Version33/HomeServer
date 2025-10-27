{
  description = "NixOS Home Server with native service integration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixarr.url = "github:rasmus-kirk/nixarr";
  };

  outputs = { self, nixpkgs, nixarr }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
    # NixOS configuration
    nixosConfigurations = {
      # Main server configuration
      # To deploy: sudo nixos-rebuild switch --flake .#homeserver
      homeserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixarr.nixosModules.default
          ./nixos/configuration.nix
        ];
      };
    };

    # Packages for VM testing
    packages.x86_64-linux = {
      # Build the VM: nix build .#vm
      # Run with: ./result/bin/run-nixos-vm
      vm = self.nixosConfigurations.homeserver.config.system.build.vm;

      # Default package
      default = self.packages.x86_64-linux.vm;
    };

    # Development shell with tools
    devShells.x86_64-linux.default = pkgs.mkShell {
      name = "homeserver-dev";

      buildInputs = with pkgs; [
        # Command runner
        just

        # Nix tools
        nixfmt-classic
        nil  # Nix language server

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
