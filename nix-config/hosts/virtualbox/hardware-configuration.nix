{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Basic file systems (adjust as needed for your setup)
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  # Swap (adjust size as needed)
  swapDevices = [ ];

  # Virtualbox-specific settings
  virtualisation.virtualbox.guest.enable = true;

  # VirtualBox typically doesn't need complicated hardware optimizations
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # Enable auto-detection of the display
  services.xserver.videoDrivers = [ "virtualbox" "vmware" "qxl" ];
  
  # Hardware acceleration
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Network configuration (typically DHCP for VirtualBox)
  networking.useDHCP = lib.mkDefault true;

  # No special hardware drivers needed for VirtualBox
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}