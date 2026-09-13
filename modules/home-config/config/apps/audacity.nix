{
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
with lib;
{
  options.lv426.apps.audacity.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable audacity";
  };

  config = mkIf config.lv426.apps.audacity.enable {

    home.packages = with pkgs; [
      audacity
    ];
  };
}