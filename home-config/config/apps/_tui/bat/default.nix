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
  cfg = config.${namespace}.apps._tui.bat;
in
{
  # https://github.com/sharkdp/bat
  home = {
    packages = with pkgs; [ 
      bat                  # A better cat
      bat-extras.batman    # bat but for man pages
    ];

    shellAliases = {
      cat = "bat";
      man = "batman";
    };
  };

  programs.bat = {
    enable = true;
  };
}