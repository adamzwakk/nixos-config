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
  cfg = config.${namespace}.apps.feh;
in
{
  options.${namespace}.apps.feh = with types; {
    enable = mkBoolOpt false "Enable feh";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ feh ]; };
}