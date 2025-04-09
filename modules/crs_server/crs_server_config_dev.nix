{ config, lib, pkgs, ... }:

{
  # Required for secrets
  age.secrets.postgres_password_dev = {
    file = ../secrets/postgres_password_dev.age;
    mode = "0400";
    owner = "crs";
  };

  services.crs_server = {
    environment = [
      "ENV=development"
      "PORT=3000"
      "LOG_LEVEL=debug"
      "POSTGRES_PASSWORD=${builtins.readFile config.age.secrets.postgres_password_dev.path}"
    ];
  };
} 