{ config, lib, pkgs, ... }:

{
  age.secrets.crs_env = {
    file = ../secrets/crs_server.env.age;
    mode = "0600";
    owner = "crs";
  };
}
