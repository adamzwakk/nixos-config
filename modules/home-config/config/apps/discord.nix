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
      "float,class:^(discord)$"
    ];
    exec-once = lib.mkAfter [
      "discord --start-minimized"
    ];
  };

  programs.niri.settings = {
    spawn-at-startup = lib.mkAfter [
      { argv = ["discord" "--start-minimized"]; }
    ];
    window-rules = lib.mkAfter [
      {
        matches = [ { app-id = "discord"; } ] ;
        open-floating = true;
      }
    ];
  };
}