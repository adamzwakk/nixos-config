{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.lv426.services.hyprlock.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable hyprlock";
  };

  config = mkIf config.lv426.services.hyprlock.enable {
    programs.hyprlock.enable = true;

    security.pam.services = { 
      hyprlock = {};
    };
  };
}