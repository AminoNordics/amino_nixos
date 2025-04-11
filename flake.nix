{
  description = "Amino NixOS configurations: dev, prod, installer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
    crs-server.url = "path:/Users/ask/git/crs_server";
    # crs-server.url = "path:/root/crs_server";
    # amino-api-v2.url = "path:/Users/ask/git/amino_api";

    agenix.inputs.nixpkgs.follows = "nixpkgs";
    crs-server.inputs.nixpkgs.follows = "nixpkgs";
    # amino-api-v2.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, agenix, crs-server, ... }: {
    # NixOS configurations
    nixosConfigurations = {
      # Development environment with Caddy
      dev = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { 
          crs_server = crs-server;
          # amino_api_v2 = amino-api-v2;
        };
        modules = [
          agenix.nixosModules.default
          ./hosts/base.nix
          ./modules/caddy.nix
          ./modules/postgresv2.nix
          ./modules/crs_server/crs_server.nix
          ./modules/crs_server/crs_server_config_dev.nix
          # ./modules/amino_api_v2/amino_api_v2.nix
          # ./modules/amino_api_v2/amino_api_v2_config_dev.nix

        ];
      };

      installer_do = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          agenix.nixosModules.default
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

    # Import devShell configuration
    devShells = import ./devshell.nix { inherit self nixpkgs flake-utils crs-server ; };
  };
}
