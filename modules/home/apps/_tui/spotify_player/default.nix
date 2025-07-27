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
  cfg = config.${namespace}.apps._tui.spotify_player;
in
{
  options.${namespace}.apps._tui.spotify_player = with types; {
    enable = mkBoolOpt false "Enable Spotify";
  };

  # https://github.com/aome510/spotify-player
  config = mkIf cfg.enable { 
    home.packages = with pkgs; [ 
      spotify-player 
    ]; 
  };
}