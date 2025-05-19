# Modular NixOS Configuration

This is a beginner-friendly modular NixOS configuration featuring Sway, Neovim, and Zsh. This setup provides a clean, organized way to manage your system configuration with separate modules for different aspects of the system.

## Features

- **Window Manager**: Sway (Wayland-based tiling window manager)
- **Editor**: Neovim with sensible defaults and useful plugins
- **Shell**: Zsh with useful aliases and integrations
- **Multiple Host Support**: Configurations for both physical laptop and VirtualBox VM
- **Modular Design**: Clean separation of concerns with specialized configuration files

## Directory Structure

- `flake.nix`: The entry point for the configuration
- `hosts/`: Contains host-specific configurations
  - `laptop.nix` & `laptop/hardware-configuration.nix`: Configuration for physical laptop
  - `virtualbox.nix` & `virtualbox/hardware-configuration.nix`: Configuration for VirtualBox VM
- `modules/`: Contains system-wide modules
  - `apps.nix`: GUI applications
  - `power-save.nix`: Power management settings (for laptops)
  - `sway.nix`: Sway window manager system configuration
  - `system.nix`: Base system configuration
  - `utillities.nix`: CLI tools and utilities
  - `virtualisation.nix`: Virtualization tools (Docker, QEMU/KVM)
- `home/`: Contains Home Manager configurations
  - `home.nix`: Main Home Manager configuration
  - `neovim.nix`: Neovim configuration
  - `sway.nix`: Sway window manager user configuration
  - `zsh.nix`: Zsh configuration

## Getting Started with VirtualBox

### Prerequisites

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Download the latest [NixOS ISO](https://nixos.org/download.html) (minimal ISO is recommended)

### Setting up the VM

1. Create a new VM in VirtualBox:
   - Type: Linux
   - Version: Other Linux (64-bit)
   - Memory: 4096 MB (at least)
   - Hard disk: Create a VDI (VirtualBox Disk Image), at least 20 GB
   - Enable EFI: No (use BIOS)

2. Before starting the VM, adjust these settings:
   - System > Processor: 2+ CPUs
   - Display > Video Memory: 128 MB
   - Display > Graphics Controller: VMSVGA

3. Boot from the NixOS ISO

### Installation Steps

1. Once booted into the NixOS live environment, partition your disk:
   ```bash
   sudo -i
   parted /dev/sda -- mklabel msdos
   parted /dev/sda -- mkpart primary 1MiB -8GiB
   parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
   mkfs.ext4 -L nixos /dev/sda1
   mkswap -L swap /dev/sda2
   swapon /dev/sda2
   mount /dev/disk/by-label/nixos /mnt
   ```

2. Clone this repository:
   ```bash
   nix-shell -p git
   git clone https://github.com/yourusername/nixos-config.git /mnt/etc/nixos
   cd /mnt/etc/nixos/nix-config
   ```

3. Install NixOS using the virtualbox configuration:
   ```bash
   nixos-install --flake .#virtualbox
   ```

4. Set the root password when prompted

5. Reboot into your new system:
   ```bash
   reboot
   ```

### Post-Installation

1. Login with username `egrapa` and the password you set during installation

2. Enjoy your new Sway desktop! Here are some basic keybindings:
   - `Super+Return`: Open terminal (Kitty)
   - `Super+d`: Open application launcher (Wofi)
   - `Super+Shift+q`: Close focused window
   - `Super+arrow keys` or `Super+h/j/k/l`: Navigate between windows
   - `Super+Shift+e`: Exit Sway

## Using on a Physical Laptop

To use this configuration on a physical laptop:

1. Boot from the NixOS ISO

2. Follow the same installation steps, but adjust the partitioning for your disk setup, and use:
   ```bash
   nixos-install --flake .#laptop
   ```

## Customizing the Configuration

### Changing Default User

Edit these files to change the default username:
- `home/home.nix`: Change `home.username` and `home.homeDirectory`
- `modules/system.nix`: Change `users.users.egrapa`
- `modules/virtualisation.nix`: Change `users.users.egrapa.extraGroups`

### Adding Software

- System-wide packages: Add to `modules/apps.nix` or `modules/utilities.nix`
- User-specific packages: Add to `home/home.nix` in the `home.packages` section

### Updating the Configuration

Apply changes to your system with:
```bash
sudo nixos-rebuild switch --flake /etc/nixos/nix-config#virtualbox
```

Replace `virtualbox` with `laptop` if you're on a physical laptop.

## Troubleshooting

### Display Issues in VirtualBox

If you have issues with the display in VirtualBox:
- Try adding `virtualisation.virtualbox.guest.x11 = true;` to `hosts/virtualbox.nix`
- Make sure 3D acceleration is enabled in VirtualBox settings

### Sway Not Starting

Check Sway logs with:
```bash
journalctl -xe
```

Ensure that your hardware is properly configured in the corresponding hardware-configuration.nix file.