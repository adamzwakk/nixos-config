{
  options,
  config,
  lib,
  pkgs,
  namespace,
  flake-inputs,
  ...
}:
{
  home.packages = with pkgs; [
    flake-inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.sm64coopdx.default
    flake-inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.sm64ex.default
  ];

  wayland.windowManager.hyprland.settings.windowrule = lib.mkAfter [
    "float,class:^(sm64.*)$"
  ];
}