{ config, pkgs, lib, ... }:

{
  imports = [
    "${pkgs.path}/nixos/modules/virtualisation/digital-ocean-image.nix"
  ];

  environment.systemPackages = with pkgs; [
    curl git gvisor overmind docker kubo grpcurl
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";         # Required for DigitalOcean init access
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    # Replace with your actual SSH public key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpB1XsuiQeP6q95awWAp6RBOd0r246yLHTVUzcgJPa7 aksel@stadler.no"
  ];

  networking = {
    hostName = "nixos-do";
    firewall.allowedTCPPorts = [ 22 80 443 8080 ];
  };

  system.stateVersion = "23.11";  # Or the NixOS version you're using
}