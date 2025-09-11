{
  lib,
  config,
  pkgs,
  ...
}:
{
  ## User only really used for TUI music
  imports = [
    ../config/desktop/hyprland
    ../config/desktop/bars/waybar

    ../config/apps/_browsers/firefox      # Need for spotify login
    ../config/apps/_tui/spotify_player
  ];
}