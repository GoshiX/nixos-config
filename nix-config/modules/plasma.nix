{ config, pkgs, lib, ... }:

{
  # KDE Plasma 6 with Wayland (no X11)
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;  # For Qt5 apps
  };

  # Display Manager (SDDM) with Wayland
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "breeze";
    };
    defaultSession = "plasma";  # Use "plasma" for Plasma 6 Wayland
  };

  # Ensure Wayland is used, not X11
  services.xserver.enable = false;  # Explicitly disable X11 server
  
  # Make sure XDG portals work with KDE
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk  # For GTK apps
    ];
  };

  # KDE-specific packages
  environment.systemPackages = with pkgs; [
    # KDE applications
    kate
    konsole
    dolphin
    ark
    okular
    gwenview
    spectacle  # Screenshot tool
    
    # KDE theming
    libsForQt5.breeze-qt5
    libsForQt5.breeze-gtk
    
    # Wayland-specific tools
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    kdePackages.plasma-wayland-protocols
    
    # Useful KDE utilities
    kdePackages.kdeconnect-kde
    kdePackages.kio-extras
    kdePackages.elisa  # Music player
  ];

  # Environment variables for Wayland
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";  # For Electron apps
  };
  
  # Font configuration
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];
}