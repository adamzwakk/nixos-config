{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../config
    ../users/music.nix
  ];

  home.stateVersion = "25.05";
}