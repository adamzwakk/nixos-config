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
  cfg = config.${namespace}.apps.flameshot;
in
{
  options.${namespace}.apps.flameshot = with types; {
    enable = mkBoolOpt false "Enable flameshot";
  };

  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;
      package = (pkgs.flameshot.override { enableWlrSupport = true; });
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          allowMultipleGuiInstances = false;
          autoCloseIdleDaemon = true;
          startupLaunch = false;
          showDesktopNotification = false;
        };
      };
    };
  };
}