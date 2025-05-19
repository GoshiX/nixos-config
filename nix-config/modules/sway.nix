{ config, pkgs, ... }:
{
  ##### Display Manager (SDDM) #####
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "breeze";  # Nice KDE-like theme
    };
    # Make sure Sway is available in the display manager
    defaultSession = "sway";
  };

  ##### Core Sway/Wayland System Configuration #####
  programs.sway = {
    enable = true;
    wrapperFeatures = {
      gtk = true;  # GTK3 integration
      base = true;  # Base Sway functionality
    };
  };

  # Enable Swaylock to work with PAM
  security.pam.services.swaylock = {};

  ##### Essential WM Packages #####
  environment.systemPackages = with pkgs; [
    # Sway Essentials
    swayidle
    swaylock
    swaybg
    wlr-randr
    wofi

    # Wayland Utilities
    wl-clipboard
    cliphist
    grim
    slurp
    mako
    wlsunset
    wayland-utils
    waybar

    # Display Control
    brightnessctl

    # Fonts & Themes
    gnome.adwaita-icon-theme
    libsForQt5.breeze-qt5
  ];

  # Set environment variables for Wayland
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    WLR_NO_HARDWARE_CURSORS = "1"; # Helps with cursor in VMs
  };

  # Ensure SEATD service is running (required for Sway)
  services.seatd.enable = true;

  # Ensure XDG portal is properly set up
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk 
    ];
  };
  
  # Enable Polkit for privilege elevation
  security.polkit.enable = true;
}