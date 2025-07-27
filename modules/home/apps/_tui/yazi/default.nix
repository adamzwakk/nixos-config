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
  cfg = config.${namespace}.apps._tui.yazi;
in
{
  options.${namespace}.apps._tui.yazi = with types; {
    enable = mkBoolOpt false "Enable yazi";
  };

  # https://github.com/sxyazi/yazi
  config = mkIf cfg.enable { 
    home = {
      shellAliases = {
        y = "yazi";
      };
      packages = with pkgs; [ 
        yazi
      ];
    };

    programs.yazi = {
      enable = true;

      enableBashIntegration = true;
    };
  };
}