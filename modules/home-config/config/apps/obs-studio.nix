{
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
with lib;
{
  options.lv426.apps.obs-studio.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable obs-studio";
  };

  config = mkIf config.lv426.apps.obs-studio.enable {

    home.packages = with pkgs; [
      obs-studio
    ];
  };
}