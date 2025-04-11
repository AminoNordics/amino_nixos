{ config, lib, pkgs, ... }:

{
  # Required for secrets
  age.secrets.postgres_connection_string_dev = {
    file = ../../secrets/postgres_connection_string.age;
    mode = "0400";
    owner = "amino_api";
  };

  age.secrets.cqrs_jwt_secret_dev = {
    file = ../../secrets/cqrs_jwt_secret.age;
    mode = "0400";
    owner = "amino_api";
  };

  age.secrets.mongodb_uri_dev = {
    file = ../../secrets/mongodb_uri.age;
    mode = "0400";
    owner = "amino_api";
  };

  services.amino_api_v2 = {
    environment = [
      "ENV=development"
      "POSTGRES_CONNECTION_STRING=postgresql://amino_api:$(<${config.age.secrets.postgres_password.path})@localhost:5433/amino_api"
      "CQRS_JWT_SECRET=$(<${config.age.secrets.cqrs_jwt_secret_dev.path})"
      "MONGODB_URI=$(<${config.age.secrets.mongodb_uri_dev.path})"
      "MONGODB_DB_NAME=amino"
    ];
  };
} 