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
    {
      nixosConfigurations = {
        dev = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
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

        installer_do = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
            ./hosts/installer_do.nix
            {
              virtualisation = {
                vmVariant = {
                  virtualisation = {
                    diskSize = 4096;  # Size in MB
                    memorySize = 2048;  # RAM in MB
                    qemu.options = [ "-smp 2" ];  # 2 CPU cores
                  };
                };
              };
            }
          ];
        };

        installer_cirrus7 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/installer_cirrus7.nix
          ];
        };
      };
    };
}
