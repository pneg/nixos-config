{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "user";
  home.homeDirectory = "/home/user";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  imports = [
    ./modules/sway-setup.nix
    ./modules/zsh.nix
  ];

  nixpkgs.overlays = [
    (
      final: prev:
      {
        #alpaca = prev.alpaca.override { ollama = prev.ollama-rocm; };
        nnn = prev.nnn.override { withNerdIcons = true; };
      }
    )
  ];

  #nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Window Manager
    #sway
    xwayland
    swaylock
    swaybg
    swaysome
    waybar
    foot
    foot.themes
    foot.terminfo
    bemenu
    fuzzel
    wl-clipboard
    wlsunset
    chayang
    cliphist
    sway-contrib.grimshot
    brightnessctl
    mako
    playerctl

    # Tools
    xorg.xeyes
    ripgrep
    fd
    bat
    nasm
    figlet
    zsh
    libqalculate
    nix-index


    # TEMPORARY PLEASE DELETE
    waylock
    wlock
    gtklock
    #cthulock

    # Audio
    pipewire
    pavucontrol

    # Fonts
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    noto-fonts
    terminus_font
    font-awesome

    # GUI Applications
    keepassxc
    gimp
    krita
    valent
    libreoffice-fresh

    # Flatpak
    flatpak
    gnome-software

    # Containers
    podman
    distrobox
    boxbuddy
    appimage-run

    # Browsers
    #brave
    #firefox
    #librewolf
    mullvad-browser
    tor-browser

    # Email
    thunderbird

    # Messaging
    weechat
    element-desktop
    nheko
    halloy

    # AI
    alpaca

    # Development
    # Languages
    lua5_4
    mitschemeX11
    sbcl

    # libs
    love

    # Language Servers
    clang-tools
    omnisharp-roslyn
    jdt-language-server
    nil
    lua-language-server

    # IDEs
    vim-full
    racket
    emacs-gtk
    #jetbrains.rider

    # File Utilities
    nautilus
    file-roller
    gtrash
    baobab
    # enable gtk applications to use xdg-user-dirs
    xdg-user-dirs-gtk

    # Document Viewers
    papers
    zathura
    foliate

    # Image viewer
    geeqie

    # Books
    calibre

    # Music
    gnome-music
    localsearch

    # Videos
    mpv
    yt-dlp

    # Gaming
    radeontop

    # Crypto
    electrum
    feather
  ];
  # required to autoload fonts from packages installed via Home Manager
  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/dotfiles/.vimrc";
    ".tmux.conf".source = dotfiles/.tmux.conf;
    ".config/doom/config.el".source = dotfiles/.config/doom/config.el;
    ".config/doom/init.el".source = dotfiles/.config/doom/init.el;
    ".config/doom/packages.el".source = dotfiles/.config/doom/packages.el;
    ".config/foot/foot.ini".source = dotfiles/.config/foot/foot.ini;
    #".config/mako/config".source = dotfiles/.config/mako/config;
    ".config/sway/config".source = dotfiles/.config/sway/config;
    ".config/sway/config.d/swaysome.conf".source = dotfiles/.config/sway/config.d/swaysome.conf;
    ".config/sway/backgrounds/special.png".source = dotfiles/.config/sway/backgrounds/special.png;
    ".config/sway/backgrounds/normal.png".source = dotfiles/.config/sway/backgrounds/normal.png;
    ".config/sway/backgrounds/city.png".source = dotfiles/.config/sway/backgrounds/city.png;
    ".config/sway/backgrounds/lockscreen.png".source = dotfiles/.config/sway/backgrounds/lockscreen.png;
    ".config/waybar/config".source = dotfiles/.config/waybar/config;
    ".config/waybar/style.css".source = dotfiles/.config/waybar/style.css;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };


  # Themes
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Material-Dark";
      package = pkgs.gruvbox-material-gtk-theme;
    };
    iconTheme.name = "Gruvbox-Material-Dark";
  };
  home.pointerCursor = {
    gtk.enable = true;
    name = "Capitaine Cursors (Gruvbox)";
    size = 32;
    package = pkgs.capitaine-cursors-themed;
  };

  # xdg user dirs
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Programs
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      profile = "high-quality";
      gpu-context = "wayland";
    };
  };
  programs.nnn = {
    enable = true;
    plugins = {
      mappings = {
      };
      #src = ;
    };
  };

  # Allow home-manager to manage shell
  programs.bash = {
    enable = false;
    initExtra = "set -o vi
    trap 'echo -ne \"\\033]0;\${PWD}: (\${BASH_COMMAND})\\007\"' DEBUG";
  };


  home.sessionVariables = {
    EDITOR = "vim";
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
    _JAVA_AWT_WM_NONREPARENTING = 1; # https://github.com/swaywm/sway/issues/595
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
