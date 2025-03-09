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
  cfg = config.${namespace}.apps.transmission-remote;
in
{
  options.${namespace}.apps.transmission-remote = with types; {
    enable = mkBoolOpt false "Enable transmission-remote";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ transmission-remote-gtk ]; };
}