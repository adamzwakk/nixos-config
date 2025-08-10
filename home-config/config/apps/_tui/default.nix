{
  pkgs,
  ...
}:
{
  imports = [
    ./bat
    ./eza
    ./yazi
  ];

  home.packages = with pkgs; [ 
    reddit-tui
    spotify-player 
  ]; 
}