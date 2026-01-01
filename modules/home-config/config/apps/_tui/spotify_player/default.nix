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
    # flake-inputs.spotify-player.defaultPackage.x86_64-linux
    #flake-inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.spotify-player.default
  ];
}