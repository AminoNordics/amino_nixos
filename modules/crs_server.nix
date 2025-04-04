{ config, lib, pkgs, crs_server, ... }:

let
  enabled = config.role == "full" || config.role == "worker";
  binary = crs_server.packages.${pkgs.system}.default;
in
{
  config = lib.mkIf enabled {
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
        User = "crs";
        WorkingDirectory = "/var/lib/crs";
        EnvironmentFile = config.age.secrets.crs_env.path;
      };
    };
  };
}