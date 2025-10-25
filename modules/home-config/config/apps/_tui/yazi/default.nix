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
  # https://github.com/sxyazi/yazi
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

  stylix.targets.yazi.enable = true;
}