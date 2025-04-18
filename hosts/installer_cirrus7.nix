{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  isoImage.isoName = "amino-installer-cirrus7.iso";
  networking.hostName = "amino-installer-cirrus7";

  # Hardware support for Cirrus7
  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;  # AMD CPU microcode updates
  };

  # Include hardware-related tools
  environment.systemPackages = with pkgs; [
    pciutils  # For lspci
    usbutils  # For lsusb
    ethtool   # For ethernet diagnostics
    iw        # For wireless diagnostics
    firmware-linux-nonfree  # Non-free firmware that might be needed
  ];

  # Basic networking
  networking = {
    useDHCP = true;
    # Enable both wired and wireless support
    wireless.enable = true;
    networkmanager.enable = true;
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDT5IwBIxoCffAjoKXpBMluCwAsT8/dFoPYyjpJD5xAAYNeYh3mQtK3tjhhc5Th8ITy9tH4sk1bp6mY8Ok6PI3F6/+v7/SyI9S6J/bQ2iXY1MiA6kBFguFLoaej7xhaSW91ua0dCS6X9RYDW4EWPnGFxXVJV1PTWEAhQIGaKysYqdOhouZbhzCfsB0GoJB8c+BhqE+M6BmsmLTaxDj55i9Bw4mCbfqpaJPSn3fubULfWtqQrb5EbE4n2GydKivYOki6RGr9Xezou8BLx9Tz19iDsBPeOzEP5/xqWsOVZOOZmK3U0yZft0cj3Pjt7RRqNYqVscm2dzLYpLeSHEjyEyPyVu0SILT7XH0n91Fk+YbGq8sE1awcXGgjXCbjFkCJobSGrBor0rjSpC+NOflArVT1KM+oSTjQxAh6tFIiGIIhuKa4fnKSBpCwa3jcfM6wJTlUldL1t6AX+QTUgPBVOJvAh9EFTHgPdkHa/HWsEGkyMVP0N9/AO11XS2Hl6ivRXJBHU+WekN5+DzK2v1XklmooABEc6ZOQ5bCfcrTe8905AkmpLK2C9yT6D0yyZRuPG5Z94acFWCuQo01aS2f7mydPPT+3YsnNeFmjvnO2j8PQsQfxlnfV1+tot9I2cNf7725IadnsMKKMyDyhX9eoEhUkr8E7xUaMSQwnxF1Wec4UJw== ask@Aksels-MacBook-Pro.local"
  ];

  system.stateVersion = "24.05";
}
