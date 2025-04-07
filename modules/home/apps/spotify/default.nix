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

  config = mkIf cfg.enable { home.packages = with pkgs; [ spotify spotify-player ]; };
}