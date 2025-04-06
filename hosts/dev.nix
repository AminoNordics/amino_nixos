{ config, pkgs, ... }:

{
  networking.hostName = "amino-dev";
  role = "full";

  time.timeZone = "Europe/Oslo";

  users.users.root.openssh.authorizedKeys.keys = [
    # Add your SSH pubkey here (this is required for initial access)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpB1XsuiQeP6q95awWAp6RBOd0r246yLHTVUzcgJPa7 aksel@stadler.no"
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "24.05";
}
