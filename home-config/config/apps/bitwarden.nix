{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    bitwarden-desktop
  ];

  wayland.windowManager.hyprland.settings = {
    windowrule = lib.mkAfter [
      "float,class:^(Bitwarden)$"
    ];
  };
}