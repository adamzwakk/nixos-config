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
  cfg = config.${namespace}.desktop.kde;
in
{
  options.${namespace}.desktop.kde = with types; {
    enable = mkBoolOpt false "Enable KDE";
  };

  config = mkIf cfg.enable {
    programs.plasma = {
      enable = true;

      session = {
        sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };

      #
      # Some high-level settings:
      #
      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 24;
        };
        iconTheme = "breeze";
        wallpaperSlideShow = {
          path = "/home/adam/Pictures/Wallpapers";
          interval = 1800;
        };
      };

      panels = [
        # Windows-like panel at the bottom
        {
          location = "bottom";
          widgets = [
            {
              kickoff = {
                sortAlphabetically = true;
                icon = "nix-snowflake-white";
              };
            }
            {
              name = "org.kde.plasma.icontasks";
              config = {
                General = {
                  launchers = [
                    "applications:firefox.desktop"
                    "applications:org.kde.dolphin.desktop"
                    "applications:Alacritty.desktop"
                  ];
                };
              };
            }
            # If no configuration is needed, specifying only the name of the
            # widget will add them with the default configuration.
            "org.kde.plasma.marginsseparator"
            # If you need configuration for your widget, instead of specifying the
            # the keys and values directly using the config attribute as shown
            # above, plasma-manager also provides some higher-level interfaces for
            # configuring the widgets. See modules/widgets for supported widgets
            # and options for these widgets. The widgets below shows two examples
            # of usage, one where we add a digital clock, setting 12h time and
            # first day of the week to Sunday and another adding a systray with
            # some modifications in which entries to show.
            {
              systemTray.items = {
                shown = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.volume"
                ];
                hidden = [
                  "org.kde.plasma.clipboard"
                  "org.kde.plasma.bluetooth"
                ];
              };
            }
            {
              digitalClock = {
                calendar.firstDayOfWeek = "sunday";
                time.format = "12h";
              };
            }
          ];
          height = 36;
          hiding = "autohide";
        }
      ];

      powerdevil = {
        AC = {
          powerButtonAction = "lockScreen";
          autoSuspend = {
            action = "sleep";
            idleTimeout = 1800;
          };
          dimDisplay = {
            enable = true;
            idleTimeout = 600;
          };
          turnOffDisplay = {
            idleTimeout = 900;
            idleTimeoutWhenLocked = 60;
          };
        };
        battery = {
          powerButtonAction = "sleep";
          whenSleepingEnter = "standbyThenHibernate";
        };
        lowBattery = {
          whenLaptopLidClosed = "sleep";
        };
      };

      kscreenlocker = {
        lockOnResume = true;
        timeout = 10;
      };

      #
      # Some mid-level settings:
      #
      shortcuts = {
        ksmserver = {
          "Lock Session" = [
            "Screensaver"
            "Meta+L"
          ];
        };

        "services/Alacritty.desktop"."New" = "Meta+Return";
        "services/plasma-manager-commands.desktop"."Alacritty" = "Meta+Enter";

        kwin = {
          "Window Close" = "Meta+Shift+Q";
        };
      };

      #
      # Some low-level settings:
      #
      configFile = {
        kwinrc = {
          NightColor = {
            Active = true;
            LatitudeFixed = 43.50518845419847;
            LongitudeFixed = "-81.75810620300753";
            Mode = "Location";
            NightTemperature = 2300;
          };
        };
      #   baloofilerc."Basic Settings"."Indexing-Enabled" = false;
      #   kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "SF";
      #   kwinrc.Desktops.Number = {
      #     value = 8;
      #     # Forces kde to not change this value (even through the settings app).
      #     immutable = true;
      #   };
      #   kscreenlockerrc = {
      #     Greeter.WallpaperPlugin = "org.kde.potd";
      #     # To use nested groups use / as a separator. In the below example,
      #     # Provider will be added to [Greeter][Wallpaper][org.kde.potd][General].
      #     "Greeter/Wallpaper/org.kde.potd/General".Provider = "bing";
      #   };
      };
    };
  };
}