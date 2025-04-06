{ config, lib, pkgs, ... }:

{
  config = lib.mkIf enabled {
    services.caddy = {
      enable = true;
      email = "testnixos@stadler.com";

      virtualHosts."test.nixos.akselerasjon.no" = {
        extraConfig = ''
          reverse_proxy localhost:5055
        '';
      };
    };
  };
}
