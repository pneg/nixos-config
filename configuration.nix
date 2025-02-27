# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./modules/nix-ld.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Console font
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
    packages = with pkgs; [ terminus_font ];
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  environment.pathsToLink = [
    "/share/zsh"
  ];
  users.users.nixosvmtest.isSystemUser = true;
  users.users.nixosvmtest.initialPassword = "test";
  users.users.nixosvmtest.group = "nixosvmtest";
  users.groups.nixosvmtest = {};

  # Automatic garbage collection
  nix.gc.automatic = true;
  nix.gc.dates = "03:15"; # Optional; allows customizing optimisation schedule

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ]; # Optional; allows customizing optimisation schedule

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # cli basics
    git # used by Flakes to clone dependencies
    vim-full # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    killall
    htop
    tmux
    dig
    whois
    neofetch
    unzip
    python3Full
    pciutils
    gnupg
    usql

    # build tools
    gcc
    gnumake
    pkg-config
    cmake
    elfutils

    # man pages
    linux-manual
    man-pages
    man-pages-posix
    gcc.man
    gcc.info

    # gui basics
    ly
    sway

    # custom
    vopono
    wireguard-tools
    polychromatic
    opensd

    (pkgs.writeShellScriptBin "toggle-bt-radio" ''
      #!/bin/bash

      if bluetoothctl show | grep "Powered: yes"; then
        bluetoothctl power off
        bluetoothctl discoverable off
      else
        bluetoothctl power on
      fi
    '')

    (pkgs.writeShellScriptBin "toggle-wifi-radio" ''
      #!/bin/bash

      if [ $(nmcli -c no radio wifi) == "disabled" ]; then
        nmcli radio all on
      else
        nmcli radio all off
      fi
    '')
  ];

  # user configuration
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  programs.sway.enable = true;

  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };

  programs.bash.promptInit = ''
    if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
      PROMPT_COLOR="1;31m"
      ((UID)) && PROMPT_COLOR="1;32m"
      PS1="  \[\e[$PROMPT_COLOR\]λ \w \[\e[0m\]"
    fi
    '';

  # Printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.foomatic-db-ppds ];
  };

  # Tor
  services.tor = {
    enable = true;
    client.enable = true;
  };

  # help me
  system.activationScripts.binbash = ''
    mkdir -m 0755 -p /bin
    ln -sfn "${pkgs.bash.out}/bin/bash" "/bin/.bash.tmp"
    mv "/bin/.bash.tmp" "/bin/bash"
  '';

  # Enable developer man pages
  documentation.dev.enable = true;
  # use man -k
  #documentation.man.generateCaches = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # Display manager
  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    animation = "matrix";
  };

  # GVFS
  services.gvfs.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
