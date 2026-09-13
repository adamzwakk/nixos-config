{
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
with lib;
{
  config = mkIf lv426.desktop.hyprland.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
    };

    stylix.targets.rofi.enable = true;
  };
}