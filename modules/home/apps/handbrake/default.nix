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
  cfg = config.${namespace}.apps.handbrake;
in
{
  options.${namespace}.apps.handbrake = with types; {
    enable = mkBoolOpt false "Enable Handbrake";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ handbrake ]; };
}