{ config, pkgs, ... }:

{
  networking.hostName = "amino-dev";
  amino.role = "dev";
}