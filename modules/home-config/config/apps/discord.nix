{
  lib,
  config,
  pkgs,
  flake-inputs,
  lv426,
  ...
}:
with lib;
{
  options.lv426.apps.discord.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable discord";
  };

  config = mkIf config.lv426.apps.discord.enable {

    home.packages = with pkgs; [
      discord
    ];
  };
}
