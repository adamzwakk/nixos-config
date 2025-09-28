{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.lv426.services.greetd.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable greetd as the display manager";
  };

  config = mkIf config.lv426.services.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd hyprland";
          user = "greeter";
        };
      };
    };

    environment.etc."greetd/environments".text = ''
      hyprland
      bash
    '';

    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}