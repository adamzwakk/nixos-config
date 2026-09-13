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
  ];

  lv426 = {
    apps = {
      alacritty.enable = true;
      audacity.enable = true;
      bitwarden.enable = true;
      discord.enable = true;
      filezilla.enable = true;
      gimp.enable = true;
      mpv.enable = true;
      obs-studio.enable = true;
      obsidian.enable = true;
      vscode.enable = true;
    };

    services = {
      syncthing.enable = true;
      wlsunset.enable = true;
    };
  };

  stylix = {
    enable = true;
    image = wallpaper;
  };

  programs.waybar.style = lib.optionalString config.programs.waybar.enable ''
    * {
        font-family: '0xProto Nerd Font';
        font-size: 12px;
        min-height: 0;
      }
  '';

  home.stateVersion = "26.05";
}