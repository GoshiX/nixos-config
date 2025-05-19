{ config, pkgs, ... }:
{
  # Docker
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;  # Clean up unused images/containers
    # Enable rootless mode (recommended for security)
    rootless = {
      enable = true;
      setSocketVariable = true;  # Sets DOCKER_HOST env var
    };
  };

  # QEMU/KVM (full virtualization)
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;  # Required for default NAT networking
      swtpm.enable = true;  # TPM emulation (for Windows VMs)
    };
  };

  # VirtualBox-specific settings when running as a guest
  virtualisation.virtualbox.guest = {
    enable = true;
    x11 = false;  # We're using Wayland, not X11
  };

  # Add user to required groups
  users.users.egrapa.extraGroups = [ "docker" "libvirtd" "kvm" ];

  # System packages (management tools)
  environment.systemPackages = with pkgs; [
    docker-compose  # Manage multi-container apps
    virt-manager    # GUI for QEMU/KVM
    qemu            # CLI tools
    spice-gtk       # Better VM display integration
    virt-viewer     # Simple VM viewer
  ];
  
  # Firewall rules for VM networking
  networking.firewall = {
    trustedInterfaces = [ "virbr0" ];  # libvirt bridge interface
    allowedTCPPorts = [ 5900 5901 ];  # VNC ports (for remote viewing)
  };
}