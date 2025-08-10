{
  options,
  config,
  lib,
  pkgs,
  ...
}:
{
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
    # ... other packages
    # pkgs.kitty # required for the default Hyprland config

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
}