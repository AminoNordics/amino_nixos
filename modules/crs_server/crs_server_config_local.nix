{ config, lib, pkgs, ... }:

{
  services.crs_server = {
    environment = [
      "ENV=development"
      "PORT=3000"
      "LOG_LEVEL=debug"
      "POSTGRES_PASSWORD=development"  # Simple password for local development
    ];
  };
} 