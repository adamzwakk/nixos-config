{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.waybar.style = lib.optionalString config.programs.waybar.enable ''
    * {
        font-family: '0xProto Nerd Font';
        font-size: 14px;
        min-height: 0;
      }
  '';

  # https://wiki.hyprland.org/Configuring/Monitors/
  wayland.windowManager.hyprland.settings.monitor = ", highrr, auto, 1";

  home.stateVersion = "25.05";
}