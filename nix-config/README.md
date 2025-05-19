# Modular NixOS Configuration

This is a beginner-friendly modular NixOS configuration featuring a choice between Sway (Wayland tiling window manager) or KDE Plasma (Wayland desktop environment), plus Neovim and Zsh. This setup provides a clean, organized way to manage your system configuration with separate modules for different aspects of the system.

## Features

- **Window Managers/Desktop Environments**:
  - Sway (Wayland-based tiling window manager)
  - KDE Plasma 6 (Wayland-based desktop environment)
- **Editor**: Neovim with sensible defaults and useful plugins
- **Shell**: Zsh with useful aliases and integrations
- **Multiple Host Support**: Configurations for both physical laptop and VirtualBox VM
- **Modular Design**: Clean separation of concerns with specialized configuration files
- **Wayland Only**: No X11 dependencies at all for maximum modern compatibility

## Directory Structure

- `flake.nix`: The entry point for the configuration
- `hosts/`: Contains host-specific configurations
  - `laptop/`: Configuration for physical laptop
    - `configuration.nix`: Main configuration
    - `hardware-configuration.nix`: Hardware-specific settings
  - `virtualbox/`: Configuration for VirtualBox VM
    - `configuration.nix`: Main configuration
    - `hardware-configuration.nix`: Hardware-specific settings
- `modules/`: Contains system-wide modules
  - `apps.nix`: GUI applications
  - `plasma.nix`: KDE Plasma desktop environment
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
   cd /mnt/etc/nixos
   ```

3. Install NixOS using the virtualbox configuration:
   ```bash
   nixos-install --flake ./nix-config#virtualbox
   ```

4. Set the root password when prompted

5. Reboot into your new system:
   ```bash
   reboot
   ```

### Post-Installation

1. Login with username `egrapa` and the password you set during installation

2. Enjoy your new desktop! Default is Sway with these basic keybindings:
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
   nixos-install --flake ./nix-config#laptop
   ```

## Switching Desktop Environments

This configuration supports both Sway (tiling window manager) and KDE Plasma (desktop environment). To switch:

1. Edit your host's configuration.nix file (in `hosts/virtualbox/configuration.nix` or `hosts/laptop/configuration.nix`):

   For Sway:
   ```nix
   imports = [
     # ...other imports
     ../../modules/sway.nix
     # ...other modules
   ];
   ```

   For KDE Plasma:
   ```nix
   imports = [
     # ...other imports
     ../../modules/plasma.nix
     # ...other modules
   ];
   ```

2. Apply the changes:
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos/nix-config#virtualbox
   # Or for laptop:
   sudo nixos-rebuild switch --flake /etc/nixos/nix-config#laptop
   ```

3. Log out and select your chosen environment from the SDDM login screen

## Home Manager Integration

This configuration uses Home Manager (integrated as a NixOS module) to manage user-level configurations. This means:

1. System-level configuration is in the `modules/` directory
2. User-level configuration is in the `home/` directory
3. Changes to both apply with a single `nixos-rebuild switch` command

To add a new Home Manager module:

1. Create a new file in the `home/` directory (e.g., `home/firefox.nix`)
2. Add your configuration
3. Import it in `home/home.nix`
4. Apply changes with `nixos-rebuild switch`

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
- Make sure you have at least 128MB video memory allocated
- Try increasing video memory to 256MB
- VirtualBox guest additions should be properly configured already

### Sway Not Starting

Check Sway logs with:
```bash
journalctl -xe
```

Make sure you have enabled the SDDM display manager and that Wayland is properly configured.

### KDE Plasma Issues

If you have issues with KDE Plasma:
- Make sure you've enabled Plasma 6 (not 5) as it is Wayland-based by default
- Check if the proper imports are present in your host configuration