{ config, lib, pkgs, ... }:

{
  age.secrets.postgres_password = {
    file = ../secrets/postgres_password.age;
    mode = "0400";
    owner = "postgres";
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;

    authentication = ''
      local   all     all                     peer
      host    all     all     127.0.0.1/32     md5
    '';

    ensureUsers = [
      {
        name = "admin";
        # Superuser privileges
        ensureDBOwnership = true;

        # Use the agenix-decrypted secret at runtime
        passwordFile = config.age.secrets.postgres_password.path;
      }
    ];

    # Create a default database for the main user (optional)
    ensureDatabases = [ "crs" ];
  };
}