{ config, lib, pkgs, ... }:

{
  # Required for secrets
  age.secrets.postgres_password_dev = {
    file = ../../secrets/postgres_password.age;
    mode = "0400";
    owner = "crs";
  };

  services.crs_server = {
    environment = [
      "ENV=development"
      "PORT=5055"
      "POSTGRES_PASSWORD=$(<${config.age.secrets.postgres_password_dev.path})"
    ];
  };
} 