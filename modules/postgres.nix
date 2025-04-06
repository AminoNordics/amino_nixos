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

    initialScript = pkgs.writeText "init.sql" ''
      DO $$
      BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'admin') THEN
          CREATE ROLE admin WITH LOGIN PASSWORD '${builtins.readFile config.age.secrets.postgres_password.path}' SUPERUSER;
        END IF;
      END
      $$;
    '';

    ensureDatabases = [ "crs" ];
  };
}