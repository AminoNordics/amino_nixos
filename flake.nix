{
  description = "Amino NixOS configurations: dev, prod, installer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
    crs-server.url = "path:../crs-server";

    agenix.inputs.nixpkgs.follows = "nixpkgs";
    crs-server.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, agenix, crs-server, ... }: {
    nixosConfigurations = {
      dev = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { crs_server = crs-server; };
        modules = [
          agenix.nixosModules.default
          ./hosts/dev.nix
          ./modules/agenix.nix
          ./modules/postgres.nix
          ./modules/crs_server.nix
          ./modules/caddy.nix
        ];
      };

      installer_do = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/installer_do.nix
        ];
      };

      # You can add prod_worker and prod_database like this later:
      # prod_worker = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [ ./hosts/prod_worker.nix ./modules/crs_server.nix ];
      # };

      # prod_database = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [ ./hosts/prod_database.nix ./modules/postgres.nix ];
      # };
    };
  };
}