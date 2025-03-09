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
  cfg = config.${namespace}.apps.makemkv;
in
{
  options.${namespace}.apps.makemkv = with types; {
    enable = mkBoolOpt false "Enable MakeMKV";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ makemkv ]; };
}