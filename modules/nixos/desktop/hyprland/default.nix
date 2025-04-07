{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.hyprland;
in
{
  options.${namespace}.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to use hyprland as the desktop environment.";
  };

  config = mkIf cfg.enable {
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

    environment.systemPackages = [
      # ... other packages
      # pkgs.kitty # required for the default Hyprland config

      pkgs.mako
      pkgs.libnotify
      pkgs.pwvucontrol
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}