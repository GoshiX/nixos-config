{ config, pkgs, inputs, ... }:

{
  imports = [
    ./neovim.nix
    ./sway.nix
    ./zsh.nix
  ];

  # Basic Home Manager settings
  home = {
    username = "egrapa";
    homeDirectory = "/home/egrapa";
    stateVersion = "23.11";

    # Packages that should be installed specifically for the user
    packages = with pkgs; [
      # Development tools
      vscode
      firefox  # Developer-friendly browser
      
      # Utilities
      ripgrep
      fd
      bat
      exa  # Modern ls replacement
      htop
      bottom # Modern system monitor
      
      # Media
      mpv
      feh
      
      # Other
      papirus-icon-theme # Nice icon theme
      gnome.adwaita-icon-theme
    ];
    
    # Create default configuration files
    file = {
      # Background image for Sway
      ".background".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-simple-blue.png";
        sha256 = "sha256-H59m1Vzr+76JJyFqiJsxf1ZMGL0SBhBXzq1CqxJJv/k=";
      };
      
      # Add custom scripts directory
      ".local/bin" = {
        source = pkgs.writeTextDir "bin/.keep" "";
        recursive = true;
      };
    };
  };

  # Enable Home Manager
  programs.home-manager.enable = true;

  # Configure Git
  programs.git = {
    enable = true;
    userName = "User Name";  # Change this
    userEmail = "user@example.com";  # Change this
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # GTK/Qt theming (required for Sway)
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # XDG Desktop Portal configuration (required for Wayland)
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "nvim.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/*" = "imv.desktop";
        "video/*" = "mpv.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # Systemd services for user session
  services = {
    # SSH agent service
    ssh-agent.enable = true;

    # GPG agent for password management
    gpg-agent = {
      enable = true;
      pinentryFlavor = "gtk2";
      enableSshSupport = true;
    };
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    BROWSER = "firefox";
    
    # Wayland specific
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
  
  # Directory for temporary files
  xdg.cacheHome = "${config.home.homeDirectory}/.cache";
}