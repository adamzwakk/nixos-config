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
    ./systems/TKF13.nix
  ];

  home.stateVersion = "25.05";
}