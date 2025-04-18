{ lib, ... }: {
  options = {
    services.crs_server.environment = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Environment variables for CRS server";
    };

    systemd.services = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Stub for systemd.services used in devshell eval";
    };

    users.users = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "Stub for users.users used in devshell eval";
    };
  };
}