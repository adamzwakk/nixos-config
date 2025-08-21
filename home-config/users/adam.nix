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

    ../config/apps/discord.nix
  ];

  home.packages = with pkgs; [
    vscodium

    yt-dlp
    bitwarden-desktop
    obsidian
    gimp3
    filezilla
    obs-studio
    qbittorrent
    audacity
  ];
}