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
  ];

  lv426 = config.lv426;

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