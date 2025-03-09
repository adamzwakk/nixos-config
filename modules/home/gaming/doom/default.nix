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
  cfg = config.${namespace}.gaming.doom;
in
{
  options.${namespace}.gaming.doom = with types; {
    enable = mkBoolOpt false "Enable Doom";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gzdoom
    ];
  };
}