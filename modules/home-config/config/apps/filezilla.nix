{
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
{
  home.packages = with pkgs; [
    filezilla
  ];
}