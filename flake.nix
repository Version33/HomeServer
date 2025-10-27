{
  description = "NixOS Incus Home Server Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.incus-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };

    # VM build helper
    packages.x86_64-linux = {
      vm = self.nixosConfigurations.incus-server.config.system.build.vm;
    };
  };
}
