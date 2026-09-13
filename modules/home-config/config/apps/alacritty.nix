{
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
with lib;
{
  options.lv426.apps.alacritty.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable alacritty";
  };

  config = mkIf config.lv426.apps.alacritty.enable {
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

    stylix.targets.alacritty.enable = true;
  };
}