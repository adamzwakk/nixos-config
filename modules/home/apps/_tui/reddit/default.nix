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
  cfg = config.${namespace}.apps._tui.reddit;
in
{
  options.${namespace}.apps._tui.reddit = with types; {
    enable = mkBoolOpt false "Enable reddit-tui";
  };

  # https://github.com/tonymajestro/reddit-tui
  config = mkIf cfg.enable { 
    home.packages = with pkgs; [ 
      reddit-tui
    ]; 
  };
}