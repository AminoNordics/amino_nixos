{ config, lib, pkgs, ... }:

{
  services.amino_api_v2 = {
    environment = [
      "ENV=local"
      "POSTGRES_CONNECTION_STRING=postgresql://amino_api:development@localhost:5433/amino_api"
      "CQRS_JWT_SECRET=development_secret"
      "MONGODB_URI=mongodb://localhost:27017"
      "MONGODB_DB_NAME=amino"
    ];
  };
} 