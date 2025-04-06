{ config, pkgs, ... }:

{
  networking.hostName = "amino-dev";

  time.timeZone = "Europe/Oslo";
  fileSystems."/" = {
  device = "/dev/disk/by-label/nixos";
  fsType = "ext4";
};

boot.loader.grub.enable = true;
boot.loader.grub.devices = [ "/dev/vda" ];

users.groups.app = { };

users.users.app = {
  isSystemUser = true;
  group = "app";
  createHome = true;
  home = "/var/lib/app";
};

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
