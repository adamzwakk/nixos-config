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
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.hypridle}/bin/hypridle &
    ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
    gnome-keyring-daemon --start --daemonize &
    export SSH_AUTH_SOCK

    ${pkgs.swww}/bin/swww init &
    sleep 1
    ${pkgs.swww}/bin/swww img ${../_wallpapers/wallhaven-0p69qe.png} &
  '';
in
{
  options.${namespace}.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

    home.packages = with pkgs; [
      hyprprop
      yazi
    ];

    ## sorta basing off https://github.com/dc-tec/nixos-config/blob/main/modules/graphical/desktop/hyprland/default.nix
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        exec-once = ''${startupScript}/bin/start'';

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

        windowrule = [
          "float,class:^(steam)$"
          "float,class:^(discord)$"
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

    programs.waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          position = "top";
          modules-left = ["hyprland/workspaces"];
          modules-center = ["hyprland/window"];
          modules-right = ["network" "battery" "clock" "tray"];

          "hyprland/workspaces" = {
            disable-scroll = true;
            sort-by-name = false;
            all-outputs = true;
            persistent-workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              # "5" = [];
              # "6" = [];
              # "7" = [];
              # "8" = [];
              # "9" = [];
              # "0" = [];
            };
          };

          "tray" = {
            icon-size = 21;
            spacing = 10;
          };

          "clock" = {
            timezone = "America/Toronto";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "  {:%d/%m/%Y}";
            format = "  {:%H:%M}";
          };

          "network" = {
            format-wifi = "{icon} ({signalStrength}%)  ";
            format-ethernet = "{ifname}: {ipaddr}/{cidr} 󰈀 ";
            format-linked = "{ifname} (No IP) 󰌘 ";
            format-disc = "Disconnected 󰟦 ";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };

          "backlight" = {
            device = "intel_backlight";
            format = "{icon}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
          };

          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon}";
            format-charging = "󰂄";
            format-plugged = "󱟢";
            format-alt = "{icon}";
            format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          };
        }
      ];

      style = ''
        * {
          font-family: '0xProto Nerd Font';
          font-size: 14px;
          min-height: 0;
        }

        #waybar {
          background: transparent;
          color: @text;
          margin: 5px 5px;
        }

        #workspaces {
          border-radius: 1rem;
          margin: 5px;
          background-color: @surface0;
          margin-left: 1rem;
        }

        #workspaces button {
          color: @lavender;
          border-radius: 1rem;
          padding: 0.4rem;
        }

        #workspaces button.active {
          color: @peach;
          border-radius: 1rem;
        }

        #workspaces button:hover {
          color: @peach;
          border-radius: 1rem;
        }

        #custom-music,
        #tray,
        #backlight,
        #network,
        #clock,
        #battery,
        #custom-lock,
        #custom-notifications,
        #custom-power {
          background-color: @surface0;
          padding: 0.5rem 1rem;
          margin: 5px 0;
        }

        #clock {
          color: @blue;
          border-radius: 0px 1rem 1rem 0px;
          margin-right: 1rem;
        }

        #battery {
          color: @green;
        }

        #battery.charging {
          color: @green;
        }

        #battery.warning:not(.charging) {
          color: @red;
        }

        #backlight {
          color: @yellow;
        }

        #custom-notifications {
          border-radius: 1rem;
          margin-right: 1rem;
          color: @peach;
        }

        #network {
          border-radius: 1rem 0px 0px 1rem;
          color: @sky;
        }

        #custom-music {
          color: @mauve;
          border-radius: 1rem;
        }

        #custom-lock {
            border-radius: 1rem 0px 0px 1rem;
            color: @lavender;
        }

        #custom-power {
            margin-right: 1rem;
            border-radius: 0px 1rem 1rem 0px;
            color: @red;
        }

        #tray {
          margin-right: 1rem;
          border-radius: 1rem;
        }

        @define-color rosewater #f4dbd6;
        @define-color flamingo #f0c6c6;
        @define-color pink #f5bde6;
        @define-color mauve #c6a0f6;
        @define-color red #ed8796;
        @define-color maroon #ee99a0;
        @define-color peach #f5a97f;
        @define-color yellow #eed49f;
        @define-color green #a6da95;
        @define-color teal #8bd5ca;
        @define-color sky #91d7e3;
        @define-color sapphire #7dc4e4;
        @define-color blue #8aadf4;
        @define-color lavender #b7bdf8;
        @define-color text #cad3f5;
        @define-color subtext1 #b8c0e0;
        @define-color subtext0 #a5adcb;
        @define-color overlay2 #939ab7;
        @define-color overlay1 #8087a2;
        @define-color overlay0 #6e738d;
        @define-color surface2 #5b6078;
        @define-color surface1 #494d64;
        @define-color surface0 #363a4f;
        @define-color base #24273a;
        @define-color mantle #1e2030;
        @define-color crust #181926;
      '';
    };
  };
}
