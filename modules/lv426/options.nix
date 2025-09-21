{ lib, config, pkgs, ... }:
with lib;
{
  options.lv426.desktop.hyprland.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable Hyprland as the desktop environment";
  };

  options.lv426.desktop.kde.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable KDE as the desktop environment";
  };

  options.lv426.services.sddm.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable SDDM as the display manager";
  };

  options.lv426.services.greetd.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable greetd as the display manager";
  };

  options.lv426.services.docker.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable docker";
  };
}