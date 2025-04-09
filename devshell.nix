{ self, nixpkgs, flake-utils, crs-server, ... }:

let
  # Define supported systems
  supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
  
  # Helper function to create system-specific outputs
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
in
  # Development environment for macOS
  forAllSystems (system: let
    pkgs = nixpkgs.legacyPackages.${system};
    baseConfig = import ./modules/devshell/devshell.nix { inherit pkgs; };
    localConfig = import ./modules/devshell/devshell_config_local.nix { inherit pkgs; };
    # Merge configurations, with localConfig taking precedence
    config = pkgs.lib.recursiveUpdate baseConfig localConfig;
  in {
    default = pkgs.mkShell {
      buildInputs = with pkgs; [
        git
        vim
        curl
        htop
        lsof
        postgresql_15
        crs-server.packages.${system}.default
      ];

      shellHook = ''
        # Start PostgreSQL
        echo "Starting PostgreSQL..."
        pg_ctl -D $PGDATA start || true
        
        # Set environment variables from config
        ${pkgs.lib.concatStringsSep "\n" (map (env: "export ${env}") config.services.crs_server.environment)}
        
        # Create database if it doesn't exist
        createdb crs || true
        
        # Start the CRS server
        crs_server
      '';
    };
  }); 