{ config, pkgs, lib, ... }:
{
  services.postgresql = {
    enable = true;
    enableTCPIP = true; # allow localhost TCP access
    settings.listen_addresses = "127.0.0.1"; # do NOT expose externally

    authentication = pkgs.lib.mkOverride 10 ''
      # Allow local Unix socket access (optional, can remove if only TCP)
      local all all trust
      # Allow localhost TCP access with password
      host all all 127.0.0.1/32 md5
      host all all ::1/128 md5
    '';

    # Optional: you can set port = 5433 if running multiple instances
    # port = 5432;

    # The DB and user will be created on first init only
    initialScript = pkgs.writeText "init-db" ''
      CREATE ROLE myapp WITH LOGIN PASSWORD 'changeme' CREATEDB;
      CREATE DATABASE myapp OWNER myapp;
      GRANT ALL PRIVILEGES ON DATABASE myapp TO myapp;
    '';
  };
}