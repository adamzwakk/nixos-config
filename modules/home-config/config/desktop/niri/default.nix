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

  ## Startup programs
  startupPrograms = [
    "udiskie"
  ]
  ++ lib.optionals nmEnabled [ ## Only include nm applet if we're actually using networkmanager
    "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
  ];

  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${lib.concatStringsSep "\n" (map (prog: "(${prog}) &") startupPrograms)}
  '';

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
  config = mkIf lv426.desktop.hyprland.enable {

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
        spawn-at-startup = startupPrograms;

        layout.gaps = 5;

        binds = {
          "Mod+Shift+Slash".show-hotkey-overlay = {};
          "Mod+Return" = {
            _props.hotkey-overlay-title = "Open Terminal";
            spawn-sh = lib.getExe pkgs.alacritty;
          };
          "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          "Mod+D" = {
            _props.hotkey-overlay-title = "Show Rofi";
            spawn = ["rofi" "-show" "drun"];
          };
          "Mod+Shift+E".quit = {};
          "Mod+Shift+M" = {
            _props.hotkey-overlay-title = "Open URL in MPV";
            spawn-sh = "${config.home.homeDirectory}/.local/bin/mpv/open-url.sh";
          };

          ### WINDOW MANAGEMENT ##
          "Mod+Q".close-window = {};
          "Mod+Left".focus-column-left = {};
          "Mod+Right".focus-column-right = {};
          "Mod+Up".focus-window-up = {};
          "Mod+Down".focus-window-down = {};
          "Mod+Ctrl+Left".move-column-left = {};
          "Mod+Ctrl+Right".move-column-right = {};
          "Mod+Ctrl+Up".move-window-up = {};
          "Mod+Ctrl+Down".move-window-down = {};
          # Vim keybinding of above
          "Mod+H".focus-column-left = {};
          "Mod+L".focus-column-right = {};
          "Mod+K".focus-window-up = {};
          "Mod+J".focus-window-down = {};
          "Mod+Ctrl+H".move-column-left = {};
          "Mod+Ctrl+L".move-column-right = {};
          "Mod+Ctrl+K".move-window-up = {};
          "Mod+Ctrl+J".move-window-down = {};

          "Mod+Shift+V".switch-focus-between-floating-and-tiling = {};
          "Mod+F".maximize-column = {};
          "Mod+Ctrl+F".expand-column-to-available-width = {};

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


      icons = {
        enable = true;
        dark = "Dracula";
        package = lib.mkDefault pkgs.dracula-icon-theme;
      };
    };
  };
}
