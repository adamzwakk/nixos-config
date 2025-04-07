{
  options,
  config,
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.hyprland;
in
{
  options.${namespace}.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
      };

      packages = with pkgs; [
        hyprcursor
        hyprprop
        yazi
      ];

      pointerCursor = {
        gtk.enable = true;
        hyprcursor.enable = true;
        # x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 20;
      };
    };

    ## sorta basing off https://github.com/dc-tec/nixos-config/blob/main/modules/graphical/desktop/hyprland/default.nix
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        exec-once = [
          "hyprctl setcursor Bibata-Modern-Classic 20"
          "killall -q waybar;sleep .5 && ${pkgs.waybar}/bin/waybar"
          "${pkgs.hypridle}/bin/hypridle"
          "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
          "gnome-keyring-daemon --start --daemonize"
          "export SSH_AUTH_SOCK"
          # "killall -q swww;sleep .5 && ${pkgs.swww}/bin/swww init"
          # "sleep 1 && ${pkgs.swww}/bin/swww img ${../_wallpapers/wallhaven-5d5eg3.jpg}"
          "discord --start-minimized"
        ];

        "$mod" = "SUPER";
        "$terminal" = "alacritty";
        "$menu" = "rofi -show drun";

        animations = {
          enabled = true;
          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92"
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "menu_decel, 0.1, 1, 0, 1"
            "menu_accel, 0.38, 0.04, 1, 0.07"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
            "softAcDecel, 0.26, 0.26, 0.15, 1"
            "md2, 0.4, 0, 0.2, 1"
          ];
          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "windowsIn, 1, 3, md3_decel, popin 60%"
            "windowsOut, 1, 3, md3_accel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 3, md3_decel"
            "layersIn, 1, 3, menu_decel, slide"
            "layersOut, 1, 1.6, menu_accel"
            "fadeLayersIn, 1, 2, menu_decel"
            "fadeLayersOut, 1, 4.5, menu_accel"
            "workspaces, 1, 7, menu_decel, slide"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };

        bind = [
          # main hotkeys
          "$mod SHIFT, E, exit,"
          "$mod SHIFT, Q, killactive,"
          "$mod, l, exec, hyprlock"
          "$mod, J, layoutmsg, orientationnext"

          # Move Focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, V, togglefloating,"

          # Move window to workspace
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"

          # app hotkeys
          "$mod, Return, exec, $terminal"
          "$mod, D, exec, $menu"

          # Workspace
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
        ];

        bindm = [
          # mouse movements
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
          "$mod ALT, mouse:272, resizewindow"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 5%+s"
          ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        ];

        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        windowrule = [ ## Use hyprprop to find window names/classes to targets
          "float,class:^(steam)$"
          "float,class:^(discord)$"
          "float,class:^(com.saivert.pwvucontrol)$"
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ];
      };
    };

    # https://mynixos.com/home-manager/option/services.hypridle.settings
    # https://0xda.de/blog/2024/07/framework-and-nixos-locking-customization/
    services.hypridle = {
      enable = true;
      settings = {
        general = {
            lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances.
            before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
            after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 120;                           # 2min
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

    # Extra stuff not really needed for its own modules (for now...)

    services.mako = {
      enable = true;
      defaultTimeout = 5000;
    };

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };

    stylix.targets = {
      rofi.enable = true;
      mako.enable = true;
    };

  };
}
