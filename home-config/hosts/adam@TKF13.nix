{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../config
    ../users/adam.nix
  ];

  ## TODO: Switch to diff image
  stylix.image = "${../../_wallpapers/3x2/wallhaven-q2gpxd.jpg}";

  home.stateVersion = "25.05";
}