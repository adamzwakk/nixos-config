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
    (heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
      ];
    })
  ];
}