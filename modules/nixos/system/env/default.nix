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
  cfg = config.${namespace}.system.env;
in
{
  options.${namespace}.system.env = with types; {
    enable = mkBoolOpt false "Whether or not to enable common environment.";
  };

  config = mkIf cfg.enable {
    environment = {
      sessionVariables = {
        NIXOS_CONFIG = "/home/adam/pj/nixos-config";
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_BIN_HOME = "$HOME/.local/bin";
        # To prevent firefox from creating ~/Desktop.
        XDG_DESKTOP_DIR = "$HOME";
        EDITOR = "nvim";
        BROWSER = "firefox";
        TERMINAL = "alacritty";

        NIXOS_OZONE_WL = "1";
      };
      variables = {
        # Make some programs "XDG" compliant.
        LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
        LESSKEY = "$XDG_CACHE_HOME/less/lesskey";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
      };
    };
  };
}
