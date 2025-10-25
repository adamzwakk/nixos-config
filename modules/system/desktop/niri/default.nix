{
  options,
  config,
  lib,
  pkgs,
  flake-inputs,
  ...
}:
with lib;
{
  options.lv426.desktop.niri.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable Niri as the desktop environment";
  };

  config = mkIf config.lv426.desktop.niri.enable {
    nixpkgs.overlays = [ flake-inputs.niri.overlays.niri ];

    programs = {
      niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
      hyprlock.enable = true;
    };

    security.pam.services = { 
      hyprlock = {};
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      mako
      libnotify
      pwvucontrol
      udiskie
      xfce.thunar
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };

    environment.etc."greetd/environments".text = lib.mkAfter ''
      niri'';
  };
}