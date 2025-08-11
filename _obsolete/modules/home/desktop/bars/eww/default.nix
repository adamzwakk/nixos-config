{
  options,
  config,
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.bars.eww;
in
{
  options.${namespace}.desktop.bars.eww = with types; {
    enable = mkBoolOpt false "Enable Eww";
  };

  config = mkIf cfg.enable {

    home = {
      packages = with pkgs; [
        eww

        ## These are mostly just here to make sure they are installed since common bar things
        networkmanagerapplet 
        pamixer
      ];

      ## Inspo
      # https://codeberg.org/JustineSmithies/hyprland-dotfiles/src/branch/master/.config/eww

      file = {
        ".config/eww/eww.yuck".source = ./config/eww.yuck;
        ".config/eww/eww.scss".source = ./config/eww.scss;
      };
    };

    programs.eww = {
      enable = true;
    };
    
  };
}
