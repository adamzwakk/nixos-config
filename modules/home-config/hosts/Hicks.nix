{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../config

    ../config/apps/_browsers/firefox

    ../config/apps/_tui/bat
    ../config/apps/_tui/eza
    ../config/apps/_tui/yazi

    ../config/gaming/emulation
  ];

  home.stateVersion = "25.05";
}