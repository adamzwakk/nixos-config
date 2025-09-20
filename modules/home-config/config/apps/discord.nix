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

  wayland.windowManager.hyprland.settings = {
    windowrule = lib.mkAfter [
      "float,class:^(discord)$"
    ];
    exec-once = lib.mkAfter [
      "discord --start-minimized"
    ];
  };
}