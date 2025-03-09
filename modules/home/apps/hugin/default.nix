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
  cfg = config.${namespace}.apps.hugin;
in
{
  options.${namespace}.apps.hugin = with types; {
    enable = mkBoolOpt false "Enable Hugin";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ hugin ]; };
}