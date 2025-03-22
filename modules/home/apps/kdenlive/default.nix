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
  cfg = config.${namespace}.apps.kdenlive;
in
{
  options.${namespace}.apps.kdenlive = with types; {
    enable = mkBoolOpt false "Enable Kdenlive";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ kdePackages.kdenlive ]; };
}