{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.spotify;
in
{
  options.${namespace}.apps.spotify = with types; {
    enable = mkBoolOpt false "Enable Spotify";
  };

  # https://github.com/aome510/spotify-player
  config = mkIf cfg.enable { home.packages = with pkgs; [ spotify spotify-player ]; };
}