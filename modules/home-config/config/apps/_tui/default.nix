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
    ./nvim
  ];

  home.packages = with pkgs; [ 
    reddit-tui
  ]; 
}