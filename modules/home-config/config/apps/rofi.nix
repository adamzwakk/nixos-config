{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };

  stylix.targets.rofi.enable = true;
}