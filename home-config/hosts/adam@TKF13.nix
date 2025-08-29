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
  ];

  stylix.image = "${../../_wallpapers/3x2/wallhaven-k71581.jpg}";

  home.stateVersion = "25.05";
}