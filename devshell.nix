{ self, nixpkgs, flake-utils, crs-server, ... }:

let
  systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
  forAllSystems = nixpkgs.lib.genAttrs systems;

  mkDevShell = system: let
    pkgs = nixpkgs.legacyPackages.${system};
    lib = pkgs.lib;

    # Emulate `nixosSystem` evaluation to reuse NixOS modules
    eval = lib.evalModules {
      modules = [
        {
          _module.args = {
            inherit pkgs lib;
            config = {
              # age.secrets.postgres_password_dev.path = ./dummy_password.txt;
              amino.role = "local";
              
            };
            crs_server = crs-server;
          };
        }
        ./modules/crs_server.nix
        ./modules/crs_server_config_local.nix
      ];
    };

    envVars = eval.config.services.crs_server.environment or [];
    execPath = eval.config.systemd.services.crs_server.serviceConfig.ExecStart
      or "${crs-server.packages.${system}.default or "crs_server"}";

  in pkgs.mkShell {
    name = "amino_dev";

    buildInputs = with pkgs; builtins.filter (x: x != null) [
      git vim curl htop lsof postgresql_15
      (crs-server.packages.${system}.default or null)
    ];

    shellHook = ''
      echo "Starting PostgreSQL..."
      pg_ctl -D $PGDATA start || true

      ${lib.concatStringsSep "\n" (map (e: "export ${e}") envVars)}

      createdb crs || true

      echo "Running CRS server from: ${execPath}"
      ${execPath}
    '';
  };

in forAllSystems (system: {
  amino_full = mkDevShell system;
  default = self.devShells.${system}.amino_full;
})