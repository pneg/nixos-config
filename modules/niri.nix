{
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [ nautilus ]; # needed for filepicker to function
  programs.niri.enable = true;
}
