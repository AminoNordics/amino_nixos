{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ 
    "${modulesPath}/virtualisation/digital-ocean-image.nix"
  ];

  networking.hostName = "amino-installer-do";

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDT5IwBIxoCffAjoKXpBMluCwAsT8/dFoPYyjpJD5xAAYNeYh3mQtK3tjhhc5Th8ITy9tH4sk1bp6mY8Ok6PI3F6/+v7/SyI9S6J/bQ2iXY1MiA6kBFguFLoaej7xhaSW91ua0dCS6X9RYDW4EWPnGFxXVJV1PTWEAhQIGaKysYqdOhouZbhzCfsB0GoJB8c+BhqE+M6BmsmLTaxDj55i9Bw4mCbfqpaJPSn3fubULfWtqQrb5EbE4n2GydKivYOki6RGr9Xezou8BLx9Tz19iDsBPeOzEP5/xqWsOVZOOZmK3U0yZft0cj3Pjt7RRqNYqVscm2dzLYpLeSHEjyEyPyVu0SILT7XH0n91Fk+YbGq8sE1awcXGgjXCbjFkCJobSGrBor0rjSpC+NOflArVT1KM+oSTjQxAh6tFIiGIIhuKa4fnKSBpCwa3jcfM6wJTlUldL1t6AX+QTUgPBVOJvAh9EFTHgPdkHa/HWsEGkyMVP0N9/AO11XS2Hl6ivRXJBHU+WekN5+DzK2v1XklmooABEc6ZOQ5bCfcrTe8905AkmpLK2C9yT6D0yyZRuPG5Z94acFWCuQo01aS2f7mydPPT+3YsnNeFmjvnO2j8PQsQfxlnfV1+tot9I2cNf7725IadnsMKKMyDyhX9eoEhUkr8E7xUaMSQwnxF1Wec4UJw== ask@Aksels-MacBook-Pro.local"
  ];

  system.stateVersion = "24.05";
}
