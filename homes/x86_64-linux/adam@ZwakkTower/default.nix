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
{
  lv426 = {

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
  };

  home.packages = with pkgs; [
    pkgs.lv426.sm64coopdx
  ];

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