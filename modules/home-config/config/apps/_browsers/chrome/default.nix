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
  options.lv426.apps.browsers.chrome.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable chrome browser";
  };

  config = mkIf config.lv426.apps.browsers.chrome.enable {

    programs = {
      chromium = {
        enable = true;
        extensions = [
          # {id = "";}  // extension id, query from chrome web store
        ];
      };
    };
  };
}