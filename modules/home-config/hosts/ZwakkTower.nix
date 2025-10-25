{ flake-inputs, pkgs, lib, config, ... }:
let
  wallpaper = "${flake-inputs.self}/_wallpapers/ultrawide_21x9/wallhaven-m9qj1m.jpg";
in{
  imports = [
    ../config

    ../config/_bundles/wayland_tiling
    
    ../config/desktop/bars/waybar

    ../config/apps/_browsers
    ../config/apps/_tui
    ../config/apps/filezilla.nix

    # ../config/apps/86Box
    ../config/gaming/doom
    ../config/gaming/quake
    ../config/gaming/emulation
    # ../config/gaming/heroic

    ../config/services/syncthing.nix
  ];

  home.packages = with pkgs; [
    hugin
    kdePackages.kdenlive
    makemkv
    handbrake
    transmission-remote-gtk

    flake-inputs.self.packages.${pkgs.system}.sm64coopdx.default
    flake-inputs.self.packages.${pkgs.system}.sm64ex.default
  ];

  programs.waybar.style = lib.optionalString config.programs.waybar.enable ''
    * {
        font-family: '0xProto Nerd Font';
        font-size: 14px;
        min-height: 0;
      }
  '';

  # https://wiki.hyprland.org/Configuring/Monitors/
  wayland.windowManager.hyprland.settings.monitor = ", highrr, auto, 1";

  programs.niri.settings = {
    spawn-at-startup = lib.mkAfter [
      { argv = ["swww" "img" wallpaper]; }
    ];
    outputs.DP-2 = {
      enable = true;
      mode = {
        width = 3440;
        height = 1440;
      };
    };
  };

  stylix.image = wallpaper;

  sops = {
    secrets."syncthing/ZwakkTower/key" = {};
    secrets."syncthing/ZwakkTower/cert" = {};
  };

  services = {
    syncthing = {
      key = config.sops.secrets."syncthing/ZwakkTower/key".path;
      cert = config.sops.secrets."syncthing/ZwakkTower/cert".path;
    };
  };

  home.stateVersion = "25.05";
}