{ config, pkgs, lib, modulesPath, ... }:

{
   imports = [
    "${modulesPath}/virtualisation/digital-ocean-image.nix"
    # ./modules/postgres.nix
  ];

  # Enable agenix for secret management
  age.identityPaths = [ "/var/lib/agenix/key" ];
  age.secrets = {
    postgres_password = {
      file = ../secrets/postgres_password.age;
      path = "/run/agenix.d/postgres_password";
      mode = "600";
      owner = "postgres";
      group = "postgres";
    };
  };

  environment.systemPackages = with pkgs; [
    git 
    vim
    curl
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
