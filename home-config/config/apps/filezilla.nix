{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    filezilla
  ];

  wayland.windowManager.hyprland.settings = {
    windowrule = lib.mkAfter [
      "float,class:^(filezilla)$"
    ];
  };
}