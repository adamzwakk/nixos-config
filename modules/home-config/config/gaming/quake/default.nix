{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
{
  home = {
    packages = with pkgs; [
      ironwail
    ];

    shellAliases.quake = "${pkgs.ironwail}/bin/ironwail -basedir ${config.home.homeDirectory}/Games/Quake/";
  };

  xdg.desktopEntries.quake = {
    name = "Quake";
    comment = "Launch Quake (Ironwail)";
    exec = "${pkgs.ironwail}/bin/ironwail -basedir ${config.home.homeDirectory}/Games/Quake/";
    categories = [ "Game" ];
    terminal = false;
  };

  wayland.windowManager.hyprland.settings.windowrule = lib.mkAfter [
    "float on,match:class ^(ironwail)$"
  ];
}