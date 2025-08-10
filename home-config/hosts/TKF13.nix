{
  imports = [
    ../config/desktop/hyprland.nix
    ../config/desktop/bars/waybar

    ../config/apps/_browsers
  ];

  stylix.image = "${../../../_wallpapers/ultrawide_21x9/wallhaven-m9qj1m.jpg}";

  home.stateVersion = "25.05";
}