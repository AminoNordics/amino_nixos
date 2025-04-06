{
  description = "test do image";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosconfigurations.installer_do = nixpkgs.lib.nixossystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/installer_do.nix
      ];
    };
  };
}