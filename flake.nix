{
  description = "NixOS configuration with dev service and DigitalOcean installer";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
    crs-server.url = "path:../crs-server";
  };
  outputs = { self, nixpkgs, flake-utils, agenix, crs-server, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # DigitalOcean installer package
        packages.installer_do = import ./hosts/installer_do.nix {
          inherit pkgs;
          system = system;
        };
        # Default package is the installer
        defaultPackage = self.packages.${system}.installer_do;
      }
    ) // {
      # NixOS configurations
      nixosConfigurations = {
        # Development system configuration
        dev = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            crs_server = crs-server;
          };
          modules = [
            agenix.nixosModules.default
            ./hosts/dev.nix
            ./modules/agenix.nix
            ./modules/postgres.nix
            ./modules/crs_server.nix
            ./modules/caddy.nix
          ];
        };
      };
    };
}