{
  description = "Test DO image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.installer_do = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./installer_do.nix
      ];
    };
  };
}