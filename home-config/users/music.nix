{
  lib,
  config,
  pkgs,
  flake-inputs,
  ...
}:
{
  ## User only really used for TUI music
  imports = [
    ../config/desktop/hyprland.nix
    ../config/desktop/bars/waybar

    ../config/apps/_tui/spotify_player
  ];

  stylix.autoEnable = lib.mkForce false;
}