{
  options,
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
with lib;
{
  options.lv426.apps.vscode.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable vscode";
  };

  config = mkIf config.lv426.apps.vscode.enable {
    
    home.packages = with pkgs; [
      vscodium
    ];
  };
}