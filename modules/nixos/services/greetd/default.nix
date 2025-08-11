{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
  let
    cfg = config.${namespace}.services.greetd;
  in
  {
    options.${namespace}.services.greetd = with types; {
      enable = mkBoolOpt false "Enable greetd";
    };

    config = mkIf cfg.enable {
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