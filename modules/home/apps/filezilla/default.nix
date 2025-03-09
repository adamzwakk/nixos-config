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
  cfg = config.${namespace}.apps.filezilla;
in
{
  options.${namespace}.apps.filezilla = with types; {
    enable = mkBoolOpt false "Enable Filezilla";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      filezilla
    ];
  };
}