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

  stylix.image = "${../../../_wallpapers/3x2/wallhaven-k71581.jpg}";
  programs.waybar.style = lib.optionalString config.programs.waybar.enable ''
    * {
        font-family: '0xProto Nerd Font';
        font-size: 12px;
        min-height: 0;
      }
  '';

  home.stateVersion = "25.05";
}