{ config, pkgs, lib, ... }:

let
  initScriptPath = "/etc/postgres/init.sql";
in {

  age.secrets.postgres_password = {
    file = ../secrets/postgres_password.age;
    mode = "0400";
    owner = "postgres";
  };

  systemd.services.postgresql-init = {
  wantedBy = [ "postgresql.service" ];
  before = [ "postgresql.service" ];

  serviceConfig = {
    Type = "oneshot";
    User = "postgres";

    ExecStart = pkgs.writeShellScript "generate-init-sql" ''
      mkdir -p /etc/postgres


      PASS=$(cat ${config.age.secrets.postgres_password.path})
      cat > ${initScriptPath} <<EOF
      DO \$\$
      BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'admin') THEN
          CREATE ROLE admin WITH LOGIN PASSWORD '\$PASS' SUPERUSER;
        END IF;
      END
      \$\$;
      EOF
    '';
  };
};

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;

    authentication = ''
      local   all     all                     peer
      host    all     all     127.0.0.1/32     md5
    '';

    initialScript = initScriptPath;
    ensureDatabases = [ "crs" ];
  };
}