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
  cfg = config.${namespace}.gaming.emulators;
in
{
  options.${namespace}.gaming.emulators = with types; {
    enable = mkBoolOpt false "Enable emulators";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      flips
      (retroarch.override {
        cores = with libretro; [
          parallel-n64
          snes9x
        ];
      })
    ];
  };
}