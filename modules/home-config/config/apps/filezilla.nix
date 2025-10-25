{
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
{
  home.packages = with pkgs; [
    filezilla
  ];

  wayland.windowManager.hyprland.settings = lib.mkIf lv426.desktop.hyprland.enable {
    windowrule = lib.mkAfter [
      "float,class:^(filezilla)$"
    ];
  };

  programs.niri.settings = {
    window-rules = lib.mkAfter [
      {
        matches = [ { app-id = "filezilla"; } ] ;
        open-floating = true;
      }
    ];
  };
}