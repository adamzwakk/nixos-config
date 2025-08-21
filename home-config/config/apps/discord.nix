{
  lib,
  config,
  pkgs,
  flake-inputs,
  ...
}:
{
  home.packages = with pkgs; [
    discord
  ];

  wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [
    "discord --start-minimized"
  ];
}