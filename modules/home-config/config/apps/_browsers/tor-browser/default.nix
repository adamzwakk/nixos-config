{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
{
  options.lv426.apps.browsers.tor.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable tor browser";
  };

  config = mkIf config.lv426.apps.browsers.tor.enable {

    home.packages = with pkgs; [ 
      tor-browser
    ];
  };
}