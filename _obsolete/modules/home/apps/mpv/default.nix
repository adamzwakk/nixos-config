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
  cfg = config.${namespace}.apps.mpv;
in
{
  options.${namespace}.apps.mpv = with types; {
    enable = mkBoolOpt false "Enable Mpv";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ mpv ]; };
}