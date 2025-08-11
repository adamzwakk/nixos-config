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
  # https://github.com/eza-community/eza
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
}