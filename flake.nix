{
  description = "Amino NixOS server with PostgreSQL, Caddy, crs_server, and agenix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
    crs_server.url = "path:/Users/ask/git/amino_nixos_deploy/crs_server";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    crs_server.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, agenix, crs_server, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        installer_do_image = (nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/installer_do.nix ];
        }).config.system.build.digitalOceanImage;
        
        installer_cirrus7_iso = self.nixosConfigurations.installer_cirrus7.config.system.build.isoImage;
      };

      nixosConfigurations = {
        dev = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            agenix.nixosModules.default
            ./hosts/dev.nix
            ./modules/agenix.nix
            ./modules/postgres.nix
            ({ ... }: { _module.args.crs_server = crs_server; })
            ./modules/crs_server.nix
            ./modules/caddy.nix
          ];
        };

        installer_cirrus7 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/installer_cirrus7.nix
          ];
        };
      };
    };
}
