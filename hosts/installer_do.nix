{ pkgs ? import <nixpkgs> {} }:
let
  config = {
    imports = [ <nixpkgs/nixos/modules/virtualisation/digital-ocean-image.nix> ];
  };
in
(pkgs.nixos config).digitalOceanImage

updates = {
  environment.systemPackages = with pkgs; [
    curl
    git
    gvisor
    overmind
    docker
    kubo
    grpcurl
  ];
  
    
    # Basic system configuration for DigitalOcean
    system.stateVersion = "23.11";
    
    # Setup SSH access for remote login
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "yes"; # Important for DO initial login
      settings.PasswordAuthentication = false;
    };
    
    # Users configuration
    users.users.root.openssh.authorizedKeys.keys = [
      # Add your SSH public key here
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample/Key/Replace/This"
    ];
    
    # Network configuration for DigitalOcean
    networking = {
      hostName = "nixos-do";
      firewall.allowedTCPPorts = [ 22 80 443 8080 ];
    };
} 