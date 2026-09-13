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
  options.lv426.apps.obsidian.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable obsidian";
  };

  config = mkIf config.lv426.apps.obsidian.enable {
    
    home.packages = with pkgs; [
      obsidian
    ];

    services.syncthing.settings.folders."ccjci-yo3ne" = {
      id = "ccjci-yo3ne";
      label = "Obsidian";
      path = "${config.home.homeDirectory}/Syncthing/Obsidian";
      devices = [ "Hudson" ];
    };
  };
}