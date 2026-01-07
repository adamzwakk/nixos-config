{
  lib,
  config,
  pkgs,
  flake-inputs,
  lv426,
  ...
}:
{
  home.packages = with pkgs; [
    discord
  ];

  wayland.windowManager.hyprland.settings = lib.mkIf lv426.desktop.hyprland.enable {
    windowrule = lib.mkAfter [
      "float on,match:class ^(discord)$"
    ];
    exec-once = lib.mkAfter [
      "discord --start-minimized"
    ];
  };
}