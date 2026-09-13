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
  options.lv426.apps.mpv.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable mpv";
  };

  config = mkIf config.lv426.apps.mpv.enable {
    
    home.packages = with pkgs; [
      (pkgs.mpv.override {
        scripts = [ pkgs.mpvScripts.mpris ];
      })
    ];
  };
}