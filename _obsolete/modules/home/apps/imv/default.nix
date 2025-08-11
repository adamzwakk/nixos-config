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
  cfg = config.${namespace}.apps.imv;
in
{
  options.${namespace}.apps.imv = with types; {
    enable = mkBoolOpt false "Enable imv";
  };

  config = mkIf cfg.enable { 
    home.packages = with pkgs; [ imv ];

    programs.imv = {
      enable = true;
      settings = { ## https://manpages.ubuntu.com/manpages/lunar/man5/imv-x11.5.html
        options.overlay = true;
      };
    };
  };
}