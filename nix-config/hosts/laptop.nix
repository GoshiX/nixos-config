{ config, pkgs, lib, inputs, selectedSystem, ... }:

{
  imports = [
    ../modules/apps.nix
    ../modules/sway.nix
    ../modules/system.nix
    ../modules/utillities.nix
    ../modules/virtualisation.nix
    ../modules/power-save.nix
    ./laptop/hardware-configuration.nix
  ];

  # Boot loader configuration for UEFI systems
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;  # Keep only 10 generations
    };
    efi.canTouchEfiVariables = true;
    timeout = 3;  # Boot menu timeout in seconds
  };

  # Set hostname
  networking.hostName = "nixos-laptop";
  
  # Enable networking
  networking.networkmanager.enable = true;
  
  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  
  # Graphics drivers - Enable based on your GPU
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;  # For 32-bit applications
  };
  
  # Power management
  services.tlp = {
    enable = true;
    settings = {
      # CPU settings
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      
      # PCI devices power management
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      
      # Battery charge thresholds (if supported)
      # START_CHARGE_THRESH_BAT0 = 40;
      # STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  
  # Laptop-specific services
  services = {
    # Automatic screen brightness based on ambient light (if supported)
    # light-locker.enable = true;
    
    # Enable fingerprint reader (if hardware supports it)
    # fprintd.enable = true;
    
    # Enable thermal management
    thermald.enable = true;
    
    # Enable firmware updates
    fwupd.enable = true;
    
    # Auto mounting of removable media
    gvfs.enable = true;
    
    # Enable trim for SSDs
    fstrim.enable = true;
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.11"; # Make sure to set this to your actual NixOS version
}