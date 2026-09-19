{ flake-inputs, pkgs, lib, config, lv426, ... }:
let
  wallpaper = "${flake-inputs.self}/_wallpapers/ultrawide_21x9/wallhaven-m9qj1m.jpg";
in{
  imports = [
    ../config
    ../config/_bundles/wayland_tiling
    ../config/gaming/doom
    # ../config/gaming/heroic
    ../config/gaming/quake
    ../config/gaming/emulation
    ../config/gaming/decomps/sm64
    ../config/gaming/decomps/banjo
    # ../config/gaming/decomps/mariokartwii
  ];

  lv426 = {
    apps = {
      alacritty.enable = true;
      audacity.enable = true;
      bitwarden.enable = true;
      browsers = {
        chrome.enable = false;
        firefox.enable = true;
        tor.enable = true;
      };
      discord.enable = true;
      filezilla.enable = true;
      gimp.enable = true;
      mpv.enable = true;
      obs-studio.enable = true;
      obsidian.enable = true;
      qbittorrent.enable = true;
      rss.enable = true;
      vscode.enable = true;
    };

    services = {
      syncthing.enable = true;
      wlsunset.enable = true;
    };
  };

  home.packages = with pkgs; [
    hugin
    kdePackages.kdenlive
    # makemkv
    handbrake
    transmission-remote-gtk
  ];

  programs.waybar.style = lib.optionalString config.programs.waybar.enable ''
    * {
        font-family: '0xProto Nerd Font';
        font-size: 14px;
        min-height: 0;
      }
  '';

  # https://wiki.hyprland.org/Configuring/Monitors/
  wayland.windowManager.hyprland.settings.monitor = [{
    output = "";
    mode = "highrr";
    position = "auto";
    scale = 1;
  }];

  wayland.windowManager.niri.settings.output = {
    _args = [ "DP-2" ];
    mode = "3440x1440";
  };

  stylix = {
    enable = true;
    # image = wallpaper;
  };

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

  home.stateVersion = "26.05";
}