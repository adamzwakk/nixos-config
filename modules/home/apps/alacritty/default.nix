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
  cfg = config.${namespace}.apps.alacritty;
in
{
  options.${namespace}.apps.alacritty = with types; {
    enable = mkBoolOpt false "Enable Alacritty";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      alacritty
    ];

    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          #opacity = 0.9;
          dynamic_padding = true;
          decorations = "None";
          padding.x = 5;
          padding.y = 5;
        };
      };
    };
  };
}