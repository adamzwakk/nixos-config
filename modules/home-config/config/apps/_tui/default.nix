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
    #./nvim
    ./yt-dlp
  ];
}