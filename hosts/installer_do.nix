{ pkgs, system }:

let
  lib = pkgs.lib;
  
  # Define the DigitalOcean installer configuration
  doInstallerConfig = { modulesPath, ... }: {
    imports = [
      "${modulesPath}/virtualisation/digital-ocean-image.nix"
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
    
    # Add the nixos-reinstall functionality for pointing to the dev configuration
    environment.systemPackages = with pkgs; [
      git
      nix-output-monitor
      
      # Custom nixos-reinstall script
      (writeScriptBin "nixos-reinstall" ''
        #!${pkgs.bash}/bin/bash
        set -e
        
        echo "Reinstalling NixOS configuration..."
        if [ -z "$1" ]; then
          echo "Usage: nixos-reinstall <flake-uri>#<config>"
          echo "Example: nixos-reinstall github:yourusername/yourrepo#dev"
          exit 1
        fi
        
        FLAKE_URI="$1"
        
        # Install the specified configuration
        ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake "$FLAKE_URI" --use-remote-sudo
        
        echo "NixOS configuration installed successfully!"
      '')
    ];
  };
  
  # Build the DigitalOcean image
  doImage = (pkgs.nixos [doInstallerConfig]).digitalOceanImage;
  
in pkgs.runCommand "installer-do" {} ''
  mkdir -p $out/nix-support
  ln -s ${doImage}/nixos.img $out/nixos-do.img
  echo "file img $out/nixos-do.img" > $out/nix-support/hydra-build-products
  
  # Add README instructions
  cat > $out/README.md << EOF
  # NixOS DigitalOcean Installer
  
  This package contains a NixOS image for DigitalOcean.
  
  ## Usage
  
  1. Upload the \`nixos-do.img\` file to DigitalOcean as a custom image
  2. Create a droplet using this custom image
  3. SSH into the droplet
  4. Run the following command to install the development environment:
     \`\`\`
     nixos-reinstall github:yourusername/yourrepo#dev
     \`\`\`
  
  ## Note
  
  Replace \`github:yourusername/yourrepo\` with the URL of your Git repository
  containing this flake configuration.
  EOF
''