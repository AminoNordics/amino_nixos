{ pkgs, ... }:

{
  services.crs_server = {
    enable = true;
    environment = [
      "ENV=development"
      "PORT=3000"
      "LOG_LEVEL=debug"
    ];
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    authentication = ''
      local   all     all                     trust
      host    all     all     127.0.0.1/32     trust
    '';
  };
} 