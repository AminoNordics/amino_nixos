{ config, lib, pkgs, ... }:

{
  imports = [
    "${pkgs.path}/nixos/modules/virtualisation/digital-ocean-image.nix"
  ];

  environment.systemPackages = with pkgs; [
    curl git gvisor overmind docker kubo grpcurl
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIYourRealSSHKeyHere"
  ];

  networking = {
    hostName = "nixos-do";
    firewall.allowedTCPPorts = [ 22 80 443 8080 ];
  };

  system.stateVersion = "23.11";
}