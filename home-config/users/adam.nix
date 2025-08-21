{
  lib,
  config,
  pkgs,
  flake-inputs,
  ...
}:
{
  imports = [
    ../config/desktop/hyprland.nix
    ../config/desktop/bars/waybar

    ../config/apps/_browsers
    ../config/apps/_tui
  ];

  home.packages = with pkgs; [
    vscodium

    yt-dlp
    bitwarden-desktop
    obsidian
    discord
    imv
    mpv
    gimp3
    filezilla
    obs-studio
    qbittorrent
    audacity
  ];

  stylix.image = "${../../_wallpapers/ultrawide_21x9/wallhaven-m9qj1m.jpg}";
}