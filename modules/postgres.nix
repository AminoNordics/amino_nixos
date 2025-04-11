# { config, pkgs, lib, ... }:

# let
#     initScriptPath = "/var/lib/postgresql/init.sql";
#     secretFile = if config.amino.role == "prod"
#     then ../secrets/postgres_password_prod.age
#     else if config.amino.role == "dev"
#     then ../secrets/postgres_password_dev.age
#     else null;  # No secret file needed for local development

# in {
#   # Only create secrets for prod and dev environments
#   age.secrets.postgres_password = lib.mkIf (secretFile != null) {
#     file = secretFile;
#     mode = "0400";
#     owner = "postgres";
#   };

#   systemd.services.postgresql-init = {
#     wantedBy = [ "postgresql.service" ];
#     before = [ "postgresql.service" ];

#     serviceConfig = {
#       Type = "oneshot";
#       User = "postgres";

#       ExecStart = pkgs.writeShellScript "generate-init-sql" ''
#         mkdir -p /var/lib/postgresql

#         ${if secretFile != null then ''
#           PASS=$(cat ${config.age.secrets.postgres_password.path})
#         '' else ''
#           PASS="development"
#         ''}
        
#         cat > ${initScriptPath} <<EOF
#         DO \$\$
#         BEGIN
#           IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'admin') THEN
#             CREATE ROLE admin WITH LOGIN PASSWORD '\$PASS' SUPERUSER;
#           END IF;

#           -- Create amino_api user and database if they don't exist
#           IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'amino_api') THEN
#             CREATE ROLE amino_api WITH LOGIN PASSWORD '\$PASS';
#           END IF;

#           IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'amino_api') THEN
#             CREATE DATABASE amino_api OWNER amino_api;
#           END IF;

#           -- Grant necessary permissions to amino_api user
#           GRANT ALL PRIVILEGES ON DATABASE amino_api TO amino_api;
#           \c amino_api
#           GRANT ALL ON SCHEMA public TO amino_api;
#           ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO amino_api;
#           ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO amino_api;
#         END
#         \$\$;
#         EOF
#       '';
#     };
#   };

#   services.postgresql = {
#     enable = true;
#     package = pkgs.postgresql_15;
#     port = 5433;  # Changed from default 5432 to 5433

#     authentication = if config.amino.role == "local" then ''
#       # Simplified authentication for local development
#       local   all             all                                     trust
#       host    all             all             127.0.0.1/32           trust
#     '' else ''
#       # Standard authentication for dev and prod
#       local   all     all                     peer
#       host    all     all     127.0.0.1/32     md5
#       host    all     all     ::1/128          md5
#     '';

#     initialScript = initScriptPath;
#     ensureDatabases = [ "crs" "amino_api" ];
#   };
# }