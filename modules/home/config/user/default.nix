{
  lib,
  config,
  pkgs,
  namespace,
  osConfig ? { },
  ...
}:
let
  inherit (lib)
    types
    mkIf
    mkDefault
    mkMerge
    ;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.config.user;
  d = config.xdg.dataHome;
  c = config.xdg.configHome;
  cache = config.xdg.cacheHome;

  home-directory = if cfg.name == null then null else "/home/${cfg.name}";
in
{
  options.${namespace}.config.user = {
    enable = mkOpt types.bool true "Whether to configure the user account.";
    name = mkOpt (types.nullOr types.str) (config.snowfallorg.user.name or "adam") "The user account.";

    fullName = mkOpt types.str "Adam Zwakenberg" "The full name of the user.";
    email = mkOpt types.str "adam@adamzwakk.com" "The email of the user.";

    home = mkOpt (types.nullOr types.str) home-directory "The user's home directory.";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "${namespace}.user.name must be set";
        }
        {
          assertion = cfg.home != null;
          message = "${namespace}.user.home must be set";
        }
      ];

      home = {
        username = mkDefault cfg.name;
        homeDirectory = mkDefault cfg.home;

        sessionVariables = {
          # clean up ~
          LESSHISTFILE = cache + "/less/history";
          LESSKEY = c + "/less/lesskey";
          WINEPREFIX = d + "/wine";

          # set default applications
          EDITOR = "nvim";
          BROWSER = "firefox";
          TERMINAL = "alacritty";

          # enable scrolling in git diff
          DELTA_PAGER = "less -R";

          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        };

        shellAliases = {
          switch = "nh os switch --update ~/pj/nixos-config";
        };
      };
    }
  ]);
}