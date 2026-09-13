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
  programs.rofi = {
    enable = hyprEnabled;
    package = pkgs.rofi;
  };

  stylix.targets.rofi.enable = hyprEnabled;
}