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
  options.lv426.apps.qbittorrent.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable qbittorrent";
  };

  config = mkIf config.lv426.apps.qbittorrent.enable {
    
    home.packages = with pkgs; [
      qbittorrent
    ];
  };
}