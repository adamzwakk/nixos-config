{ lib, config, pkgs, ... }:
with lib;
{
  options.lv426.desktop.hyprland.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable Hyprland as the desktop environment";
  };
}