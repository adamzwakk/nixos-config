{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
{
  home.packages = with pkgs; [
    uzdoom
    qzdl
  ];

  wayland.windowManager.hyprland.settings.windowrule = lib.mkAfter [
    "float on,match:class ^(zdl)$"
    "float on,match:class ^(uzdoom)$"
  ];
}