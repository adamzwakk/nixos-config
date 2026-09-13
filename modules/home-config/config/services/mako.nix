{
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
let
  hyprEnabled = lv426.desktop.hyprland.enable;
in
{
  services.mako = {
    enable = hyprEnabled;
    settings = {
      default-timeout = 5000;
    };
  };

  stylix.targets.mako.enable = true;
}