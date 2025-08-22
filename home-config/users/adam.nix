{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../config/desktop/hyprland.nix
    ../config/desktop/bars/waybar

    ../config/apps/_browsers
    ../config/apps/_tui

    ../config/apps/bitwarden.nix
    ../config/apps/discord.nix
    ../config/apps/filezilla.nix
  ];

  # No need for configs below
  home.packages = with pkgs; [
    vscodium

    yt-dlp
    obsidian
    gimp3
    obs-studio
    qbittorrent
    audacity
  ];
}