{
  description = "NixOS Incus Home Server - Proxmox Replacement";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
    # NixOS configuration for the Incus server
    nixosConfigurations = {
      # VM configuration for testing
      incus-server-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix
        ];
      };

      # Production configuration (for actual hardware deployment)
      # To deploy: nixos-rebuild switch --flake .#incus-server
      incus-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix
          # Override VM-specific settings for production
          {
            # Production security settings
            services.openssh.settings.PermitRootLogin = nixpkgs.lib.mkForce "no";
            security.sudo.wheelNeedsPassword = nixpkgs.lib.mkForce true;

            # Set proper boot device for your hardware
            # Uncomment and modify for your system:
            # boot.loader.grub.device = "/dev/sda";
          }
        ];
      };
    };

    # Packages for easy VM building and running
    packages.x86_64-linux = {
      # Build the VM: nix build .#vm
      vm = self.nixosConfigurations.incus-server-vm.config.system.build.vm;

      # Default package
      default = self.packages.x86_64-linux.vm;
    };

    # Development shell with tools
    devShells.x86_64-linux.default = pkgs.mkShell {
      name = "incus-server-dev";

      buildInputs = with pkgs; [
        # Command runner
        just

        # Nix tools
        nixfmt-classic
        nil  # Nix language server

        # Utilities
        git

        # For testing
        curl
        jq
      ];

      shellHook = ''
        echo "🚀 Incus Server Development Environment"
        echo ""
        echo "Available commands:"
        echo "  just --list    # Show all available commands"
        echo "  just run-vm    # Build and run the VM"
        echo ""
      '';
    };
  };
}
