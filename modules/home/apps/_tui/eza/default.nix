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
  cfg = config.${namespace}.apps._tui.eza;
in
{
  options.${namespace}.apps._tui.eza = with types; {
    enable = mkBoolOpt false "Enable eza";
  };

  # https://github.com/eza-community/eza
  config = mkIf cfg.enable { 
    home = {
      packages = with pkgs; [ 
        eza                  # A 'better' ls
      ];

      shellAliases = {
        ls = "eza";
        l = "eza -lah";
        tree = "eza --tree --git-ignore";
      };
    };

    programs.eza = {
      enable = true;
    };
  };
}