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
    uzdoom
    qzdl
  ];
}