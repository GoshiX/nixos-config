{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ]; # Change to kvm-amd if using AMD CPU
  boot.extraModulePackages = [ ];

  # Basic file systems - adjust based on your actual disk setup
  fileSystems."/" = {
    device = "/dev/nvme0n1p2"; # Adjust this based on your actual disk setup
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1"; # Adjust this based on your actual disk setup
    fsType = "vfat";
  };

  # Swap (adjust size as needed)
  swapDevices = [
    { device = "/dev/nvme0n1p3"; } # Adjust this based on your actual disk setup
  ];

  # Power management for battery life
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };

  # Hardware-specific settings for a typical laptop
  hardware = {
    bluetooth.enable = true;
    
    # CPU microcode updates
    cpu.intel.updateMicrocode = lib.mkDefault true; # Change if using AMD
    
    # Trackpad support
    trackpoint.enable = lib.mkDefault true;
    
    # Firmware updates
    enableRedistributableFirmware = true;
    
    # Audio
    pulseaudio.enable = false; # We use PipeWire instead
    
    # Graphics - adjust based on your GPU
    opengl = {
      enable = true;
      # Removed driSupport and driSupport32Bit due to the error
    };
  };

  # Enable laptop-specific services
  services = {
    # Thermal management
    thermald.enable = true;
    
    # Firmware updates
    fwupd.enable = true;
    
    # Power management
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      };
    };
    
    # Trim SSD periodically
    fstrim.enable = true;
  };

  # Networking configuration (typically NetworkManager for laptops)
  networking.networkmanager.enable = true;

  # Default to x86_64 architecture
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}