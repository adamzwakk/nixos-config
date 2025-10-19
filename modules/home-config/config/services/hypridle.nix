{
  # https://mynixos.com/home-manager/option/services.hypridle.settings
  # https://0xda.de/blog/2024/07/framework-and-nixos-locking-customization/
  services.hypridle = {
      enable = true;
      settings = {
        general = {
            lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances.
            before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
            after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
            ignore_dbus_inhibit = false;
        };

        listener = [
          {
            timeout = 600;                           # 10min
            on-timeout = "hyprctl dispatch dpms off";  # command to run when timeout has passed
            on-resume = "hyprctl dispatch dpms on";   # command to run when activity is detected after timeout has fired.
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
}