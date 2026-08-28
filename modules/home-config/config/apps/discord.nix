{
  lib,
  config,
  pkgs,
  flake-inputs,
  lv426,
  ...
}:
{
  home.packages = with pkgs; [
    discord
  ];
}
