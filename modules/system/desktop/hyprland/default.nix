{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.lv426.desktop.hyprland.enable {
    programs = {
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      hyprlock.enable = true;
    };

    security.pam.services = { 
      hyprlock = {};
    };

    environment.systemPackages = with pkgs; [
      mako
      libnotify
      pwvucontrol
      udiskie
      xfce.thunar
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}