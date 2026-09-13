{
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
with lib;
{
  options.lv426.apps.bitwarden.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable bitwarden";
  };

  config = mkIf config.lv426.apps.bitwarden.enable {

    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}