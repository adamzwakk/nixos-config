{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
{
  home.packages = with pkgs; [
    flips
    ryubing       # Switch Emulator
    igir          # ROM Manager
    (retroarch.withCores (cores: with cores; [ ## https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/emulators/libretro/cores
        parallel-n64
        snes9x
    ]))
  ];
}