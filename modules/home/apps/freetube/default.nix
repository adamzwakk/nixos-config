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
  cfg = config.${namespace}.apps.freetube;
in
{
  options.${namespace}.apps.freetube = with types; {
    enable = mkBoolOpt false "Enable Freetube";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      freetube
    ];

    programs.freetube = {
      enable = true;
      settings = {
        defaultViewingMode = "theatre";
        autoplayVideos = false;
        defaultQuality = "720";
        externalPlayer = "mpv";
        useSponsorBlock = true;
      };
    };

  };
}