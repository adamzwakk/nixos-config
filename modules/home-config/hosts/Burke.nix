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

    ../config/gaming/emulation
  ];

  home.stateVersion = "25.05";
}