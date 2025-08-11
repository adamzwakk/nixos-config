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
  cfg = config.${namespace}.tools.yt-dlp;
in
{
  options.${namespace}.tools.yt-dlp = with types; {
    enable = mkBoolOpt false "Enable yt-dlp";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      yt-dlp
    ];
  };
}