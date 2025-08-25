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

  stylix.image = "${../../_wallpapers/3x2/wallhaven-k71581.jpg}";
  home.stateVersion = "25.05";
}