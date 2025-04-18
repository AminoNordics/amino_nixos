{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Oslo";
  fileSystems."/" = {
  device = "/dev/disk/by-label/nixos";
  fsType = "ext4";
};

boot.loader.grub.enable = true;
boot.loader.grub.devices = [ "/dev/vda" ];

environment.systemPackages = with pkgs; [
  vim
  git
  htop
  curl
  lsof
  vscode
  xorg.xauth
];

users.groups.app = { };

users.users.app = {
  isSystemUser = true;
  group = "app";
  createHome = true;
  home = "/var/lib/app";
};

  users.users.root = {
    openssh.authorizedKeys.keys = [
      # Add your SSH pubkey here (this is required for initial access)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpB1XsuiQeP6q95awWAp6RBOd0r246yLHTVUzcgJPa7 aksel@stadler.no"
    ];
    home = "/root";
    createHome = true;
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.X11Forwarding = true;
    extraConfig = ''
      X11DisplayOffset 10
      AddressFamily inet
    '';
  };

  security.pam.services.sshd.startSession = true;

  networking.firewall.allowedTCPPorts = [ 80 443 22];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";
}
