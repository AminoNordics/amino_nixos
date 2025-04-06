{ config, lib, pkgs, crs_server, ... }:

let
  binary = crs_server.packages.${pkgs.system}.default;
in
{
    users.users.crs = {
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/crs";
    };

    systemd.services.crs_server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${binary}/bin/crs_server";
        Restart = "on-failure";
        User = "app";
        WorkingDirectory = "/var/lib/crs";
      };
    };
  }