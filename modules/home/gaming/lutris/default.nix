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
  cfg = config.${namespace}.gaming.lutris;
in
{
  options.${namespace}.gaming.lutris = with types; {
    enable = mkBoolOpt false "Enable Lutris";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lutris
    ];
  };
}