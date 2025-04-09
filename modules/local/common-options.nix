{ lib, ... }: {
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "Stub for users.users used in devshell eval.";
    };

    systemd.services = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Stub for systemd.services used in devshell eval.";
    };
  };
 
}