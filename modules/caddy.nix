{ config, lib, pkgs, ... }:

let
  enabled = config.role == "full" || config.role == "worker";
in
{
  config = lib.mkIf enabled {
    services.caddy = {
      enable = true;
      email = "you@example.com";

      virtualHosts."amino.example.com" = {
        extraConfig = ''
          reverse_proxy localhost:3000
        '';
      };
    };
  };
}
