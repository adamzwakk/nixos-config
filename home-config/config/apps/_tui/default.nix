{
  pkgs,
  ...
}:
{
  imports = [
    ./bat
    ./eza
    ./yazi
    ./spotify_player
  ];

  home.packages = with pkgs; [ 
    reddit-tui
  ]; 
}