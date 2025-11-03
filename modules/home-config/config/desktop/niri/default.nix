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
        hyprcursor      # Cursor setting
        #wpaperd
        hyprshot        # Screengrab
        mpv             # Video Player
        
        kdePackages.kate  # Text Editor (overkill?)
        kdePackages.ark   # Archive Manager
      ];

      pointerCursor = {
        gtk.enable = true;
        hyprcursor.enable = true;
        package = lib.mkForce pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 20;
      };

      file.".local/bin/mpv/open-url.sh" = {
        source = "${flake-inputs.self}/scripts/mpv/open-url.sh";
        executable = true;
      };
    };

    ## https://github.com/sodiboo/niri-flake/blob/main/docs.md#programsnirisettings
    programs.niri = {
      settings = {
        spawn-at-startup = [
          { sh = "export SSH_AUTH_SOCK"; }
          { argv = ["udiskie"]; }
        ]
        ## Only include nm applet if we're actually using networkmanager
        ++ lib.optionals nmEnabled [
          { argv = ["${pkgs.networkmanagerapplet}/bin/nm-applet" "--indicator"]; }
        ];

        binds = with config.lib.niri.actions; {
          "Super+Return".action.spawn = "alacritty";
          "Super+D".action.spawn = ["rofi" "-show" "drun"];
          "Super+Shift+L".action.spawn = "hyprlock";
          "Super+Shift+S".action.spawn = ["hyprshot" "-m" "region" "--clipboard-only"];
          "Super+E".action.spawn = "thunar";

          "Super+Shift+E".action = quit;
          "Super+Shift+Q".action = close-window;

          "Super+Left".action = focus-column-left;
          "Super+Right".action = focus-column-left;
          "Super+Shift+Left".action = move-column-left-or-to-monitor-left;
          "Super+Shift+Right".action = move-column-right-or-to-monitor-right;
          "Super+V".action = toggle-window-floating;


          "Super+1".action.focus-workspace = 1;
          "Super+2".action.focus-workspace = 2;
          "Super+3".action.focus-workspace = 3;
          "Super+4".action.focus-workspace = 4;
          "Super+5".action.focus-workspace = 5;
          "Super+6".action.focus-workspace = 6;

          "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
          "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
          "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          "XF86MonBrightnessUp".action.spawn = ["brightnessctl" "s" "5%+s"];
          "XF86MonBrightnessDown".action.spawn = ["brightnessctl" "s" "5%-"];

          "XF86AudioNext".action.spawn = ["playerctl" "next"];
          "XF86AudioPause".action.spawn = ["playerctl" "play-pause"];
          "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
          "XF86AudioPrev".action.spawn = ["playerctl" "previous"];
        };
      };
    };

    stylix = {
      targets.niri.enable = true;
      iconTheme = {
        enable = true;
        dark = "Dracula";
        package = lib.mkForce pkgs.dracula-icon-theme;
      };
    };
  };
}
