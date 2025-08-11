{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [ 
    spotify-player 
  ];

  networking.extraHosts = lib.mkAfter ''
      0.0.0.0 apresolve.spotify.com
    '';
}