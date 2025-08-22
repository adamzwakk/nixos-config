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
  stylix.image = "${../../_wallpapers/ultrawide_21x9/wallhaven-m9qj1m.jpg}";

  home.stateVersion = "25.05";
}