{
  options,
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
with lib;
{
  options.lv426.apps.gimp.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable gimp";
  };

  config = mkIf config.lv426.apps.gimp.enable {
    
    home.packages = with pkgs; [
      gimp3
    ];
  };
}