{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.lv426.desktop.hyprland.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable Hyprland as the desktop environment";
  };

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

    environment.etc."greetd/environments".text = lib.mkAfter ''
      hyprland'';
  };
}