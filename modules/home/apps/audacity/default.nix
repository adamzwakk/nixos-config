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
  cfg = config.${namespace}.apps.audacity;
in
{
  options.${namespace}.apps.audacity = with types; {
    enable = mkBoolOpt false "Enable Audacity";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ audacity ]; };
}