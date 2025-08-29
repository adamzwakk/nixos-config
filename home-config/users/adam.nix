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

  programs.git.extraConfig.github.user = "adamzwakk";
  programs.git.userEmail = "adam@adamzwakk.com";
  programs.git.userName = "adamzwakk";

  services.syncthing.settings.folders = {
    "ccjci-yo3ne" = {
      id = "ccjci-yo3ne";
      label = "Obsidian";
      path = "${config.home.homeDirectory}/Syncthing/Obsidian";
      devices = [ "Hudson" ];
    };
  };

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