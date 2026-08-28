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
  lua = lib.generators.mkLuaInline;
  dsp = {
    exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
    close = lua "hl.dsp.window.close()";
    exit = lua "hl.dsp.exit()";
    float = lua ''hl.dsp.window.float({ action = "toggle" })'';
    fullscreen = lua "hl.dsp.window.fullscreen()";
    pseudo = lua "hl.dsp.window.pseudo()";
    layout = msg: lua ''hl.dsp.layout("${msg}")'';
    focus = dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
    swap = dir: lua ''hl.dsp.window.swap({ direction = "${dir}" })'';
    toggleSpecial = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
    moveToSpecial = name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';
    focusWorkspace = ws: lua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
    moveToWorkspace = ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';
    drag = lua "hl.dsp.window.drag()";
    resize = lua "hl.dsp.window.resize()";
    sendshortcut = mod: key: lua ''hl.dsp.send_shortcut({ mods = "${mod}", key = "${key}" })'';
    pin = lua "hl.dsp.window.pin()";
  };

  bind = keys: dispatcher: { _args = [keys dispatcher]; };
  bindOpts = keys: dispatcher: opts: { _args = [keys dispatcher opts]; };

  workspaceBinds = lib.concatMap (i:
    let key = toString (lib.mod i 10);
    in [
      (bind "SUPER + ${key}" (dsp.focusWorkspace i))
      (bind "SUPER + SHIFT + ${key}" (dsp.moveToWorkspace i))
    ]
  ) (lib.range 1 10);

  startupPrograms = [
    "udiskie"
    "killall -q waybar; sleep 0.5; ${pkgs.waybar}/bin/waybar"
  ]
  ++ lib.optionals nmEnabled [ ## Only include nm applet if we're actually using networkmanager
    "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
  ];

  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${lib.concatStringsSep "\n" (map (prog: "(${prog}) &") startupPrograms)}
  '';
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
        hyprcursor      # Cursor setting
        #wpaperd
        hyprprop        # Get hyprland window info
        hyprshot        # Screengrab
        
        kdePackages.kate  # Text Editor (overkill?)
        kdePackages.ark   # Archive Manager
      ];

      pointerCursor = {
        enable = true;
        gtk.enable = true;
        hyprcursor.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 20;
      };

      file.".local/bin/mpv/open-url.sh" = {
        source = "${flake-inputs.self}/scripts/mpv/open-url.sh";
        executable = true;
      };
    };

    ## sorta basing off https://github.com/dc-tec/nixos-config/blob/main/modules/graphical/desktop/hyprland/default.nix
    ## https://www.reddit.com/r/NixOS/comments/1tg9cse/hyprland_hm_lua_config_migration/
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      settings = {
        config = {
          general = {
            gaps_in = 5;
            gaps_out = 5;
            border_size = 1;
            col = {
              active_border = "rgb(e1e1e1)";
              inactive_border = "rgb(151515)";
            };
          };

          animations = {
            enabled = true;
          };
        };

        curve = [
          {_args = [
            "linear"
            {
              type = "bezier";
              points = lua "{ {0, 0}, {1, 1} }";
            }
          ];}
          {_args = [
            "md3_accel"
            {
              type = "bezier";
              points = lua "{ {0.3, 0}, {0.8, 0.15} }";
            }
          ];}
          {_args = [
            "md3_decel"
            {
              type = "bezier";
              points = lua "{ {0.05, 0.7}, {0.1, 1} }";
            }
          ];}
          {_args = [
            "menu_accel"
            {
              type = "bezier";
              points = lua "{ {0.38, 0.04}, {1, 0.07} }";
            }
          ];}
          {_args = [
            "menu_decel"
            {
              type = "bezier";
              points = lua "{ {0.1, 1}, {0, 1} }";
            }
          ];}
        ];

        animation = [
          { leaf = "windows"; enabled = true; speed = 3; bezier = "md3_decel"; style = "popin 60%";  }
          { leaf = "windowsIn"; enabled = true; speed = 3; bezier = "md3_decel"; style = "popin 60%"; }
          { leaf = "windowsOut"; enabled = true; speed = 3; bezier = "md3_accel"; style = "popin 60%"; }
          { leaf = "border"; enabled = true; speed = 10; bezier = "default"; }
          { leaf = "fade"; enabled = true; speed = 3; bezier = "default"; }
          { leaf = "layersIn"; enabled = true; speed = 3; bezier = "menu_decel"; style = "slide"; }
          { leaf = "layersOut"; enabled = true; speed = 1.6; bezier = "md3_accel"; }
          { leaf = "fadeLayersIn"; enabled = true; speed = 3; bezier = "menu_decel"; }
          { leaf = "fadeLayersOut"; enabled = true; speed = 1.6; bezier = "md3_accel"; }          
          { leaf = "workspaces"; enabled = true; speed = 3; bezier = "menu_decel"; style = "slide"; }
        ];

        window_rule = [
          ## FLOATS
          {
            match = { class = "^(steam)$"; };
            float = true;
          }
          {
            match = { class = "^(discord)$"; };
            float = true;
          }
          {
            match = { class = "^(Bitwarden)$"; };
            float = true;
          }
          {
            match = { class = "^(filezilla)$"; };
            float = true;
          }
          {
            match = { class = "^(zdl)$"; };
            float = true;
          }
          {
            match = { class = "^(uzdoom)$"; };
            float = true;
          }
          {
            match = { class = "^(ironwail)$"; };
            float = true;
          }
          {
            match = { class = "^(sm64.*)$"; };
            float = true;
          }
          {
            match = { class = "^(com.saivert.pwvucontrol)$"; };
            float = true;
          }
          {
            match = {
              initial_class = "thunar";
              title = "(File Operation Progress.*)";
            };
            float = true;
          }
          {
            match = {
              initial_class = "thunar";
              title = "(Rename.*)";
            };
            float = true;
          }

          # OVERRIDES
          {
            match = {
              class = "^$";
              title = "^$";
              xwayland = 1;
              float = 1;
              fullscreen = 0;
              pin = 0;
            };
            no_focus = true;
          }
          {
            match = {
              class = ".*";
            };
            idle_inhibit = "fullscreen";
          }

        ];


        on = [
          {
            _args = [
              "hyprland.start"
              (lua ''
                function()
                  hl.exec_cmd("${startupScript}/bin/start")
                end
              '')
            ];
          }
        ];

        bind = [
          ## APP LAUNCHER
          (bind "SUPER + RETURN" (dsp.exec "alacritty"))
          (bind "SUPER + D" (dsp.exec "rofi -show drun"))
          (bind "SUPER + E" (dsp.exec "thunar"))
          (bind "SUPER + SHIFT + S" (dsp.exec "hyprshot -m region --clipboard-only"))
          (bind "SUPER + SHIFT + M" (dsp.exec "${config.home.homeDirectory}/.local/bin/mpv/open-url.sh"))

          # HYPRLAND
          (bind "SUPER + SHIFT + Q" dsp.close)
          (bind "SUPER + SHIFT + L" (dsp.exec "hyprlock"))
          (bind "SUPER + SHIFT + E" dsp.exit)
          (bind "SUPER + V" dsp.float)
          (bind "SUPER + left" (dsp.focus "left"))
          (bind "SUPER + right" (dsp.focus "right"))
          (bind "SUPER + up" (dsp.focus "up"))
          (bind "SUPER + down" (dsp.focus "down"))
          (bind "SUPER + SHIFT + A" dsp.pin)

          # Volume keys
          (bindOpts "XF86AudioRaiseVolume" (dsp.exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") { locked = true; repeating = true; })
          (bindOpts "XF86AudioLowerVolume" (dsp.exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") { locked = true; repeating = true; })
          (bindOpts "XF86AudioMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") { locked = true; })
          (bindOpts "XF86AudioMicMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") { locked = true; })

          ## Monitor Brightness
          (bindOpts "XF86MonBrightnessUp" (dsp.exec "brightnessctl s 5%+s") { locked = true; })
          (bindOpts "XF86MonBrightnessDown" (dsp.exec "brightnessctl s 5%-s") { locked = true; })

          ## Audio Controls
          (bindOpts "XF86AudioNext" (dsp.exec "playerctl next") { locked = true; })
          (bindOpts "XF86AudioPause" (dsp.exec "playerctl play-pause") { locked = true; })
          (bindOpts "XF86AudioPlay" (dsp.exec "playerctl play-pause") { locked = true; })
          (bindOpts "XF86AudioPrev" (dsp.exec "playerctl previous") { locked = true; })

          # Mouse move/resize
          (bindOpts "SUPER + mouse:272" dsp.drag { mouse = true; })
          (bindOpts "SUPER + mouse:273" dsp.resize { mouse = true; })
        ] ++ workspaceBinds;
      };
    };

    # Extra stuff not really needed for its own modules (for now...)

    services.hyprpaper.settings = {
      splash = false;
    };

    stylix = {
      targets.hyprland.enable = true;
      targets.hyprland.hyprpaper.enable = true;
      targets.hyprlock.enable = mkIf config.lv426.services.hyprlock.enable true;

      icons = {
        enable = true;
        dark = "Dracula";
        package = pkgs.dracula-icon-theme;
      };
    };
  };
}
