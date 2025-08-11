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
  cfg = config.${namespace}.tools.innoextract;
in
{
  options.${namespace}.tools.innoextract = with types; {
    enable = mkBoolOpt false "Enable innoextract";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      innoextract ## To open GOG Installers
    ];
  };
}