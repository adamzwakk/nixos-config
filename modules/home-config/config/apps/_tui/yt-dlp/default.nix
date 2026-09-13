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
    yt-dlp
  ];
}