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
    ../users/adam.nix
  ];

  home.stateVersion = "25.05";
}