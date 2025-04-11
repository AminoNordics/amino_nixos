{ config, lib, pkgs, amino_api_v2, ... }:

with lib;

let
  binaryPath = amino_api_v2.packages.${pkgs.system}.default;
in {
  options.services.amino_api_v2.environment = mkOption {
    type = types.listOf types.str;
    default = [];
    description = "Environment variables passed to the Amino API v2 server.";
  };

  config = {
    users.users.amino_api = {
      isSystemUser = true;
      group = "app";
      createHome = true;
      home = "/var/lib/amino_api";
    };

    systemd.services.amino_api_v2 = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${binaryPath}/bin/amino_api_v2";
        Restart = "on-failure";
        User = "amino_api";
        WorkingDirectory = "/var/lib/amino_api";
        Environment = config.services.amino_api_v2.environment;
      };
    };
  };
} 