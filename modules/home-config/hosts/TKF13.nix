{
  lib,
  config,
  pkgs,
  flake-inputs,
  ...
}:
let 
  wallpaper = "${flake-inputs.self}/_wallpapers/3x2/wallhaven-k71581.jpg";
in
{
  imports = [
    ../config

    ../config/_bundles/wayland_tiling
    
    ../config/desktop/bars/waybar

    ../config/apps/_browsers
    ../config/apps/_tui
    ../config/apps/filezilla.nix

    ../config/services/syncthing.nix
  ];

  stylix.image = wallpaper;
  programs.waybar.style = lib.optionalString config.programs.waybar.enable ''
    * {
        font-family: '0xProto Nerd Font';
        font-size: 12px;
        min-height: 0;
      }
  '';

  home.stateVersion = "25.05";
}