{ config, pkgs, lib, inputs, selectedSystem, ... }:

{
  imports = [
    ../modules/apps.nix
    ../modules/sway.nix
    ../modules/system.nix
    ../modules/utillities.nix
    ../modules/virtualisation.nix
    ./virtualbox/hardware-configuration.nix
  ];

  # Basic system configuration
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda"; # Install GRUB to the MBR
    useOSProber = true;  # Auto-detect other OS
  };
  
  # Disable EFI for VirtualBox (unless you're using EFI mode)
  boot.loader.efi.canTouchEfiVariables = false;
  
  # Set hostname
  networking.hostName = "nixos-vm";
  
  # Enable guest additions for better integration
  virtualisation.virtualbox.guest.enable = true;
  
  # Enable sound within VM (use PipeWire for compatibility)
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  
  # Enable OpenGL for Sway to work in VirtualBox
  hardware.opengl.enable = true;
  
  # Enable SDDM display manager
  services.displayManager.sddm.enable = true;
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.11"; # Make sure to set this to your actual NixOS version
}