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
  cfg = config.${namespace}.apps.bittorrent;
in
{
  options.${namespace}.apps.bittorrent = with types; {
    enable = mkBoolOpt false "Enable Bittorrent";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ qbittorrent ]; };
}