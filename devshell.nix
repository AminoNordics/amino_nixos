

let

  systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
  forAllSystems = nixpkgs.lib.genAttrs systems;

  mkDevShell = system: let
    pkgs = nixpkgs.legacyPackages.${system};
    lib = pkgs.lib;

    # Evaluate the NixOS config to extract shared config/env
    eval = lib.evalModules {
      modules = [
        ./modules/local/common-options.nix
        {
          _module.args = {
            inherit pkgs lib;
            config = {
              amino.role = "local";  # Force local config path
              age.secrets.postgres_password_dev.path = ./dummy_password.txt;
            };
            crs_server = crs-server;
            # amino_api_v2 = amino-api-v2;
            binary = "${crs-server.packages.${system}.default}";
          };
        }
        ./modules/crs_server/crs_server.nix
        ./modules/crs_server/crs_server_config_local.nix
        # ./modules/amino_api_v2/amino_api_v2.nix
        # ./modules/amino_api_v2/amino_api_v2_config_local.nix
      ];
    };

    envVars = eval.config.services.crs_server.environment or [];
    # aminoApiEnvVars = eval.config.services.amino_api_v2.environment or [];
    crsBinary = "${crs-server.packages.${system}.default}/bin/crs_server";
    # aminoApiBinary = "${amino-api-v2.packages.${system}.default}/bin/amino_api_v2";

  in pkgs.mkShell {
    name = "amino_dev";

    buildInputs = with pkgs; builtins.filter (x: x != null) [
      git vim curl htop lsof postgresql_15
      (crs-server.packages.${system}.default or null)
      # (amino-api-v2.packages.${system}.default or null)
    ];

    shellHook = ''
      echo "Starting PostgreSQL..."
      pg_ctl -D $PGDATA start || true

      ${lib.concatStringsSep "\n" (map (e: "export ${e}") envVars)}

      createdb crs || true
    
      echo "Running CRS server from: ${crsBinary}"
      ${crsBinary} &
      CRS_PID=$!


      trap 'kill $CRS_PID $AMINO_API_PID' EXIT
    '';
  };

in forAllSystems (system: {
  amino_full = mkDevShell system;
  default = self.devShells.${system}.amino_full;
})