{
  lib,
  config,
  flake-inputs,
  pkgs,
  ...
}:
with lib;
{
  options.lv426.services.wlsunset.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable wlsunset";
  };

  config = mkIf config.lv426.services.wlsunset.enable {
    home.packages = [
      pkgs.wlsunset
    ];
  
    # Blue light filter
    services.wlsunset = {
      enable = true;
      latitude = 43.5;
      longitude = -81.7;

      temperature.night = 3300;
    };
  };
}