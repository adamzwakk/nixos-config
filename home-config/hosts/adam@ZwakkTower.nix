{
  lib,
  config,
  pkgs,
  flake-inputs,
  ...
}:
{
  imports = [
    ../config

    ../config/gaming/doom
    ../config/gaming/quake
    ../config/gaming/emulation
    ../config/gaming/lutris
    ../config/gaming/quake

    ../config/services/syncthing.nix

    ../users/adam.nix
  ];

  home.packages = with pkgs; [
    hugin
    kdePackages.kdenlive
    makemkv
    transmission-remote-gtk

    flake-inputs.self.packages.${pkgs.system}.sm64coopdx.default
    flake-inputs.self.packages.${pkgs.system}.sm64ex.default
  ];

  # https://wiki.hyprland.org/Configuring/Monitors/
  wayland.windowManager.hyprland.settings.monitor = ", highrr, auto, 1";
  # services.wpaperd.settings = {
  #   DP-2 = {
  #     path = "${../../../_wallpapers/ultrawide_21x9}";
  #   };
  # };

  stylix.image = "${../../_wallpapers/ultrawide_21x9/wallhaven-m9qj1m.jpg}";

  sops.secrets."syncthing/ZwakkTower/key" = {};
  sops.secrets."syncthing/ZwakkTower/cert" = {};
  services.syncthing.key = config.sops.secrets."syncthing/ZwakkTower/key".path;
  services.syncthing.cert = config.sops.secrets."syncthing/ZwakkTower/cert".path;

  home.stateVersion = "25.05";
}