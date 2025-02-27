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
  };
  jovian.hardware.has.amd.gpu = true;
  jovian.steamos = {
    enableZram = true;
    enableBluetoothConfig = true;
    enableDefaultCmdlineConfig = true;
    enableEarlyOOM = true;
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
}
