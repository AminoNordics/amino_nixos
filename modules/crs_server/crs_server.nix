{ config, lib, pkgs, crs_server, binary, ... }:

with lib;

let
  binaryPath = crs_server.packages.${pkgs.system}.default;
in {
  # options = {
  #   services.crs_server.environment = mkOption {
  #     type = types.listOf types.str;
  #     default = [];
  #     description = "Environment variables passed to the CRS server.";
  #   };

  #   systemd.services = mkOption {
  #     type = types.attrs;
  #     default = {};
  #     description = "Systemd service definitions.";
  #   };
  # };

  config = {
    users.users.crs = {
      isSystemUser = true;
      group = "app";
      createHome = true;
      home = "/var/lib/crs";
    };

    systemd.services.crs_server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${binaryPath}/bin/crs_server";
        Restart = "on-failure";
        User = "crs";
        WorkingDirectory = "/var/lib/crs";
        Environment = config.services.crs_server.environment;
      };
    };
  };
}