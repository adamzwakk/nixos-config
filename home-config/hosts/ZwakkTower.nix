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
    ../config/desktop/hyprland.nix
    ../config/desktop/bars/waybar

    ../config/apps/_browsers
    ../config/apps/_tui

    ../config/gaming/doom
    ../config/gaming/quake
    ../config/gaming/emulation
    ../config/gaming/lutris
    ../config/gaming/quake
  ];

  home.packages = with pkgs; [
    vscodium
    hugin
    kdePackages.kdenlive
    makemkv
    transmission-remote-gtk
  ];

  stylix.image = "${../../_wallpapers/ultrawide_21x9/wallhaven-m9qj1m.jpg}";

  # https://wiki.hyprland.org/Configuring/Monitors/
  wayland.windowManager.hyprland.settings.monitor = ", highrr, auto, 1";

  home.stateVersion = "25.05";
}