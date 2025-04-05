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
  cfg = config.${namespace}.desktop.kde;
in
{
  options.${namespace}.desktop.kde = with types; {
    enable = mkBoolOpt false "Whether or not to use KDE Plasma as the desktop environment.";
  };

  config = mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;
    };
 
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      okular
      krdp
      gwenview
    ];
  };
}