{
  config,
  lib,
  pkgs,
  inputs,
  nmEnabled,
  lv426,
  flake-inputs,
  ...
}:
let  

  noctaliaExe = (lib.getExe pkgs.noctalia);

  ## Startup programs
  startupPrograms = [
    "udiskie"
    noctaliaExe
  ]
  ++ lib.optionals nmEnabled [ ## Only include nm applet if we're actually using networkmanager
    "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
  ];

  ## Floating Rules
  floatingClasses = [
    "steam"
    "discord"
    "bitwarden"
    "filezilla"
    "zdl"
    "uzdoom"
    "ironwail"
    "sm64.*"
    "com.saivert.pwvucontrol"
  ];
in
with lib;
{
  config = mkIf lv426.desktop.niri.enable {

    home = {
      sessionVariables = {
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
      };

      packages = with pkgs; [       
        kdePackages.kate  # Text Editor (overkill?)
        kdePackages.ark   # Archive Manager
      ];

      pointerCursor = {
        enable = true;
        gtk.enable = true;
        package = lib.mkDefault pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 20;
      };

      file.".local/bin/mpv/open-url.sh" = {
        source = "${flake-inputs.self}/scripts/mpv/open-url.sh";
        executable = true;
      };
    };

    wayland.windowManager.niri = {
      enable = true;
      settings = {
        _children = (map (cmd: { spawn-sh-at-startup = cmd; }) startupPrograms)
        ++ [{
          window-rule._children =
            (map (cls: { match._props.app-id = "(?i)^${cls}$"; }) floatingClasses)
              ++ [ { open-floating = true; } ];}
            { window-rule = { match._props.app-id = "^Alacritty$"; draw-border-with-background = false; }; }
          ];

        input.focus-follows-mouse = {
          _props.max-scroll-amount = "0%";
        };

        layout = {
          always-center-single-column = true;
          background-color = "transparent";
          gaps = 16;
          focus-ring = {
            width = 2;
          };
        };

        gestures.hot-corners = {
          off = {};
        };

        hotkey-overlay = {
          hide-not-bound = {};
        };

        layer-rule = {
            match._props.namespace = "^noctalia-wallpaper";
            place-within-backdrop = true;
        };

        binds = {
          "Mod+Shift+Slash".show-hotkey-overlay = {};
          "Mod+Return" = {
            _props.hotkey-overlay-title = "Open Terminal";
            spawn-sh = lib.getExe pkgs.alacritty;
          };
          "Mod+D" = {
            _props.hotkey-overlay-title = "Show Launcher";
            spawn-sh = "${noctaliaExe} msg panel-toggle launcher";
          };
          "Mod+E" = {
            _props.hotkey-overlay-title = "Open Thunar";
            spawn-sh = lib.getExe pkgs.thunar;
          };
          "Mod+Shift+L" = {
            _props.hotkey-overlay-title = "Lock Session";
            spawn-sh = "noctalia msg session lock";
          };
          "Mod+Shift+E".quit = {};
          "Mod+Shift+M" = {
            _props.hotkey-overlay-title = "Open clipboard URL in MPV";
            spawn-sh = "${config.home.homeDirectory}/.local/bin/mpv/open-url.sh";
          };
          "Mod+Shift+S" = {
            _props.hotkey-overlay-title = "Take Screenshot";
            spawn-sh = "${noctaliaExe} msg screenshot-region";
          };

          ### WINDOW MANAGEMENT ##
          "Mod+Shift+Q".close-window = {};
          "Mod+Left".focus-column-left = {};
          "Mod+Right".focus-column-right = {};
          "Mod+Up".focus-window-up = {};
          "Mod+Down".focus-window-down = {};
          "Mod+Shift+Left".move-column-left = {};
          "Mod+Shift+Right".move-column-right = {};
          "Mod+Shift+Up".move-window-up = {};
          "Mod+Shift+Down".move-window-down = {};
          # Vim keybinding of above
          # "Mod+H".focus-column-left = {};
          # "Mod+L".focus-column-right = {};
          # "Mod+K".focus-window-up = {};
          # "Mod+J".focus-window-down = {};
          # "Mod+Shift+H".move-column-left = {};
          # "Mod+Shift+L".move-column-right = {};
          # "Mod+Shift+K".move-window-up = {};
          # "Mod+Shift+J".move-window-down = {};

          "Mod+Shift+V".toggle-window-floating = {};
          "Mod+F".maximize-column = {};
          "Mod+Shift+F".fullscreen-window = {};

          ## WORKSPACE MANAGEMENT ##
          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+Shift+1".move-column-to-workspace = 1;
          "Mod+Shift+2".move-column-to-workspace = 2;
          "Mod+Shift+3".move-column-to-workspace = 3;
          "Mod+Shift+4".move-column-to-workspace = 4;
          "Mod+Shift+5".move-column-to-workspace = 5;
          "Mod+Shift+6".move-column-to-workspace = 6;

          ## VOLUME/MEDIA KEYS ##
          "XF86AudioRaiseVolume" = {
            _props.allow-when-locked = true;
            spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
          };
          "XF86AudioLowerVolume" = {
            _props.allow-when-locked = true;
            spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
          };
          "XF86AudioMute" = {
            _props.allow-when-locked = true;
            spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          };
          "XF86AudioNext" = {
            _props.allow-when-locked = true;
            spawn = ["playerctl" "next"];
          };
          "XF86AudioPause" = {
            _props.allow-when-locked = true;
            spawn = ["playerctl" "play-pause"];
          };
          "XF86AudioPlay" = {
            _props.allow-when-locked = true;
            spawn = ["playerctl" "play-pause"];
          };
          "XF86AudioPrev" = {
            _props.allow-when-locked = true;
            spawn = ["playerctl" "previous"];
          };

          ## MONITOR BRIGHTNESS ##
          "XF86MonBrightnessUp" = {
            _props.allow-when-locked = true;
            spawn = ["brightnessctl" "s" "5%+s"];
          };
          "XF86MonBrightnessDown" = {
            _props.allow-when-locked = true;
            spawn = ["brightnessctl" "s" "5%-s"];
          };
          
        };
      };
      xwaylandSatellitePackage = pkgs.xwayland-satellite;
    };

    stylix = {
      targets.hyprlock.enable = mkIf config.lv426.services.hyprlock.enable true;
      icons = {
        enable = true;
        dark = "Dracula";
        package = lib.mkDefault pkgs.dracula-icon-theme;
      };
    };
  };
}
