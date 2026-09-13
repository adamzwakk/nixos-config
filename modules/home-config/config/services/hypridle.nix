{
  config,
  lib,
  flake-inputs,
  lv426,
  ...
}:
let
  niriEnabled = lv426.desktop.niri.enable;
  noctaliaEnabled = lv426.desktop.noctalia.enable;
  hyprEnabled = lv426.desktop.hyprland.enable;

  dpmsOff = if niriEnabled
    then "niri msg action power-off-monitors"
    else "hyprctl dispatch dpms off";
  dpmsOn = if niriEnabled
    then "niri msg action power-on-monitors"
    else "hyprctl dispatch dpms on";
in
{
  # https://mynixos.com/home-manager/option/services.hypridle.settings
  # https://0xda.de/blog/2024/07/framework-and-nixos-locking-customization/
  
  services.hypridle = {
    enable = !noctaliaEnabled;
    settings = {
      general = {
          lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
          after_sleep_cmd = dpmsOn;  # to avoid having to press a key twice to turn on the display.
          ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 600;                           # 10min
          on-timeout = dpmsOff;  # command to run when timeout has passed
          on-resume = dpmsOn;   # command to run when activity is detected after timeout has fired.
        }
        {
          timeout = 300;                                 # 5min
          on-timeout = "loginctl lock-session";          # lock screen when timeout has passed
        }
        {
          timeout = 1800;                              # 30min
          on-timeout = "systemctl suspend";            # suspend pc
        }
      ];
    };
  };

  ## Easy status/disable hypridle through script/for waybar
  home.file.".local/bin/hypridle/hypridle-status.sh" = {
    source = "${flake-inputs.self}/scripts/hypridle/hypridle-status.sh";
    executable = true;
  };
  home.file.".local/bin/hypridle/hypridle-toggle.sh" = {
    source = "${flake-inputs.self}/scripts/hypridle/hypridle-toggle.sh";
    executable = true;
  };
  
}