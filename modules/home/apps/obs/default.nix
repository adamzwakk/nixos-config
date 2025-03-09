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
  cfg = config.${namespace}.apps.obs;
in
{
  options.${namespace}.apps.obs = with types; {
    enable = mkBoolOpt false "Enable OBS";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ obs-studio ]; };
}