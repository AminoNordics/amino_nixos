{ config, lib, pkgs, ... }:

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
