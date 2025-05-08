{
  config,
  lib,
  osConfig,
  namespace,
  pkgs,
  ...
}:
with lib;
with lib.${namespace};
#let
  #wps = lib.filesystem.listFilesRecursive("${../../../_wallpapers/ultrawide_21x9}");
#in
{
  lv426 = {
    desktop = {
      # kde = enabled;
      hyprland = enabled;

      bars.waybar = enabled;
    };

    gaming = {
      emulators = enabled;
      doom = enabled;
      quake = enabled;
      lutris = enabled;
    };

    apps = {
      alacritty = enabled;
      audacity = enabled;
      chrome = enabled;
      feh = enabled;
      filezilla = enabled;
      firefox = enabled;
      gimp = enabled;
      handbrake = enabled;
      hugin = enabled;
      kdenlive = enabled;
      makemkv = enabled;
      mpv = enabled;
      neovim = enabled;
      obs = enabled;
      spotify = enabled;
      transmission-remote = enabled;
      vscode = enabled;

      ## Sort this later, maybe
      unsorted = enabled;
    };

    tools = {
      git = enabled;
      yt-dlp = enabled;
      direnv = enabled;
    };

    services.sops = enabled;
  };

  home.packages = with pkgs; [
    lv426.sm64coopdx
    lv426.sm64ex
  ];

  stylix = {
    enable = true;
    image = "${../../../_wallpapers/ultrawide_21x9/wallhaven-m9qj1m.jpg}";
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/brewer.yaml"; #https://tinted-theming.github.io/tinted-gallery/
    opacity.terminal = 0.8;
    opacity.desktop = 0.5;
  };

  # https://wiki.hyprland.org/Configuring/Monitors/
  wayland.windowManager.hyprland.settings.monitor = ", highrr, auto, 1";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = lib.mkDefault (osConfig.system.stateVersion or "24.11");
}