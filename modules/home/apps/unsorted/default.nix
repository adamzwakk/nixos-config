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
  cfg = config.${namespace}.apps.unsorted;
in
{
  options.${namespace}.apps.unsorted = with types; {
    enable = mkBoolOpt false "Enable Unsorted Programs";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
      obsidian
      discord
      # ventoy-full
    ];
  };
}