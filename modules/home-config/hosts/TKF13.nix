{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../config

    ../config/desktop/hyprland
    ../config/desktop/bars/waybar

    ../config/apps/_browsers
    ../config/apps/_tui

    ../config/services/syncthing.nix
  ];

  stylix.image = "${flake-inputs.self}/_wallpapers/3x2/wallhaven-k71581.jpg";
  programs.waybar.style = lib.optionalString config.programs.waybar.enable ''
    * {
        font-family: '0xProto Nerd Font';
        font-size: 12px;
        min-height: 0;
      }
  '';

  home.stateVersion = "25.05";
}