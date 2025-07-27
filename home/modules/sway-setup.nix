{ config, pkgs, ... }:

{
  # Window Manager
  wayland.windowManager.sway.xwayland = true;
  #programs.waybar.enable = true;
  #programs.swaylock.enable = true;
  services.cliphist = {
    enable = true;
  };
  # doesn't work with ly, so we have to make our own service
  #systemd.user.services.foot = {
  #  Install.WantedBy = [ "sway-session.target" ];
  #  Service.ExecStart = "${pkgs.foot}/bin/foot --server";
  #};
  # systemd.user.services.mako = {
  #   Service.ExecStart = "${pkgs.mako}/bin/mako";
  # };
  services.mako = {
    enable = true;
    settings = {
      anchor="top-right";
      font="JetBrainsMono Nerd Font 14px";
      background-color="#282828";
      text-color="#ebdbb2";
      border-color="#ebdbb2";
      progress-color="over #ebdbb2";
    };
  };
  services.wlsunset = {
    enable = true;
    sunrise = "6:00";
    sunset = "22:00";
    temperature.night = 3000;
  };
  services.swayidle = (
    let lockCommand = "${pkgs.swaylock}/bin/swaylock -e -i ~/.config/sway/backgrounds/city.png"; in
    {
      enable = true;
      timeouts = [
        { timeout = 120; command = "${pkgs.chayang}/bin/chayang && ${lockCommand}"; }
        { timeout = 240; command = "${pkgs.systemd}/bin/systemctl suspend"; }
      ];
      events = [
        { event = "before-sleep"; command = "${lockCommand}"; }
      ];
    }
  );

  wayland.windowManager.sway = {
    enable = false;
    extraConfigEarly = "include ~/.config/home-manager/dotfiles/sway/config";
    config.seat = {
      "*" = {
        xcursor_theme = "\"${config.home.pointerCursor.name}\" ${toString config.home.pointerCursor.size}";
      };
    };
  };
}
