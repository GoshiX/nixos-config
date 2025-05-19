{ config, pkgs, ... }:
{
  # Audio configuration with PipeWire (for modern Wayland support)
  # sound.enable = true; # Removed as suggested by error message
  hardware.pulseaudio.enable = false;  # Disable PulseAudio (conflicts with PipeWire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;  # PulseAudio replacement
    jack.enable = true;   # For professional audio
  };

  # Network (NetworkManager for simplicity)
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;  # Disable wpa_supplicant if using NM

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;  # Enable GUI for Bluetooth

  # Wayland essentials - these will be configured in sway.nix
  xdg.portal = {
    enable = true;
    wlr.enable = true;          # Screen sharing for Wayland
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Hardware (GPU, input, etc.)
  hardware.opengl = {
    enable = true;
    # driSupport = true;        # Removed as suggested by error message
    # driSupport32Bit = true;   # Removed as suggested by error message
  };

  # Locale and language settings
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  # Set the time zone
  time.timeZone = "Europe/Moscow";

  # Console keymap
  console.keyMap = "us";

  # Kernel tweaks for Wayland
  boot.kernelParams = [ "quiet" "udev.log_priority=3" ];

  # Security (needed for swaylock, etc.)
  security.pam.services.swaylock = {};
  security.rtkit.enable = true;  # Realtime priority for PipeWire

  # Users (minimal setup - will be extended by other modules as needed)
  users.users.egrapa = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = false; # Will require programs.zsh.enable = true;
  };

  # Enable Zsh globally
  programs.zsh.enable = true;

  # System-wide packages (no GUI apps - those are in apps.nix)
  environment.systemPackages = with pkgs; [
    git
    wget
    seatd               # For seat management (required by Sway)
    dbus                # D-Bus integration
    glib                # GTK/Wayland utils
  ];

  # Enable fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Fira Code" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  # Enable nix flakes
  nix = {
    package = pkgs.nixVersions.stable; # Changed from pkgs.nixFlakes as requested
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      auto-optimise-store = true;
    };
  };

  # Automatically garbage collect old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}