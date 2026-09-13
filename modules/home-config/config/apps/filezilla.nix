{
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
with lib;
{
  options.lv426.apps.filezilla.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable filezilla";
  };

  config = mkIf config.lv426.apps.filezilla.enable {

    home.packages = with pkgs; [
      filezilla
    ];
  };
}