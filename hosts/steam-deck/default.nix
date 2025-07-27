{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.jovian.nixosModules.jovian
    ../../modules/gaming.nix
  ];

  networking.hostName = "deck";

  # Jovian stuff
  jovian.devices.steamdeck = {
    enable = true;
    enableOsFanControl = true;
    enableSoundSupport = false;
  };
  jovian.hardware.has.amd.gpu = true;
  jovian.steamos = {
    enableZram = true;
    enableBluetoothConfig = true;
    enableDefaultCmdlineConfig = true;
    enableEarlyOOM = true;
  };

  services.pipewire.jack.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Tablet
  boot.extraModulePackages = [ config.boot.kernelPackages.digimend ];
  #hardware.opentabletdriver = {
  #  enable = true;
  #  daemon.enable = true;
  #};

  # Mouse stuff
  hardware.openrazer.enable = true;
  users.users.user.extraGroups = [ "openrazer" ];

  # Controller
  hardware.steam-hardware.enable = true;

  # Cross-compilation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
