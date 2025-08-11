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
  cfg = config.${namespace}.apps.wlsunset;
in
{
  options.${namespace}.apps.wlsunset = with types; {
    enable = mkBoolOpt false "Enable wlsunset";
  };

  # maybe an idea if you're feeling frisky https://www.reddit.com/r/hyprland/comments/16skqzv/i_make_a_shell_script_that_control_wlsunset_from/
  config = mkIf cfg.enable { 
    home.packages = with pkgs; [ wlsunset ]; 

    services.wlsunset = {
      enable = true;
      latitude = 43.5;
      longitude = -81.7;

      temperature.night = 3300;
    };
  };
}