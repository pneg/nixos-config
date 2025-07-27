{
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    nautilus # needed for filepicker to function
    xwayland-satellite
  ];
  programs.niri.enable = true;
  programs.waybar.enable = true;
}
