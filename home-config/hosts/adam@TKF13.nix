{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../config

    ../config/services/syncthing.nix

    ../users/adam.nix
    ./systems/TKF13.nix
  ];
  home.stateVersion = "25.05";
}