{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.lv426.desktop.niri.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable niri as the desktop environment";
  };

  config = mkIf config.lv426.desktop.niri.enable {
    programs = {
      niri = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      mako
      libnotify
      pwvucontrol
      udiskie
      thunar
      xwayland-satellite # xwayland support
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    environment.etc."greetd/environments".text = lib.mkAfter ''
      ${config.programs.niri.package}/bin/niri-session'';
  };
}