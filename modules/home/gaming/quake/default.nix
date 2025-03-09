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
  cfg = config.${namespace}.gaming.quake;
in
{
  options.${namespace}.gaming.quake = with types; {
    enable = mkBoolOpt false "Enable Quake";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ironwail
    ];
  };
}