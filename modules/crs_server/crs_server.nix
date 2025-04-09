{ config, lib, pkgs, crs_server, ... }:

let
  binary = crs_server.packages.${pkgs.system}.default;

  # Define environment variables based on the deployment role
  envVars = if config.amino.role == "prod" then [
    "ENV=production"
    "PORT=3000"
    "LOG_LEVEL=info"
    # Add more prod-specific config here
    "POSTGRES_PASSWORD=${builtins.readFile config.age.secrets.postgres_password_prod.path}"
  ] else if config.amino.role == "dev" then [
    "ENV=development"
    "PORT=3000"
    "LOG_LEVEL=debug"
    # Add more dev-specific config here
    "POSTGRES_PASSWORD=${builtins.readFile config.age.secrets.postgres_password_dev.path}"
  ] else [
    # Local development settings
    "ENV=development"
    "PORT=3000"
    "LOG_LEVEL=debug"
    "POSTGRES_PASSWORD=development"  # Simple password for local development
  ];

in
{
  # Required for secrets
  age.secrets.postgres_password_dev = lib.mkIf (config.amino.role == "dev") {
    file = ../secrets/postgres_password_dev.age;
    mode = "0400";
    owner = "crs";
  };

  age.secrets.postgres_password_prod = lib.mkIf (config.amino.role == "prod") {
    file = ../secrets/postgres_password_prod.age;
    mode = "0400";
    owner = "crs";
  };

  users.users.crs = {
    isSystemUser = true;
    group = "app";
    createHome = true;
    home = "/var/lib/crs";
  };

  systemd.services.crs_server = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${binary}/bin/crs_server";
      Restart = "on-failure";
      User = "crs";
      WorkingDirectory = "/var/lib/crs";
      Environment = config.services.crs_server.environment;
    };
  };
}
