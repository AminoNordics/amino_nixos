{ config, lib, pkgs, ... }:

{
  config = lib.mkIf enabled {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      authentication = ''
        local   all     all                     peer
        host    all     all     127.0.0.1/32     md5
      '';
      initialScript = pkgs.writeText "init.sql" ''
        CREATE USER crs WITH PASSWORD 'changeme';
        CREATE DATABASE crs_db OWNER crs;
      '';
    };
  };
}
