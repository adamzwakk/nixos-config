{
  lib,
  config,
  pkgs,
  flake-inputs,
  ...
}:
{
  imports = [
    ../config
    ../users/music.nix
  ];

  home.stateVersion = "25.05";
}