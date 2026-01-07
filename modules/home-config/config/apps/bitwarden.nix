{
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
{
  home.packages = with pkgs; [
    bitwarden-desktop
  ];

  wayland.windowManager.hyprland.settings = lib.mkIf lv426.desktop.hyprland.enable {
    windowrule = lib.mkAfter [
      "float on,match:class ^(Bitwarden)$"
    ];
  };
}