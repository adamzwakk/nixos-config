{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.system.locale;
in
{
  options.${namespace}.system.locale = {
    enable = mkBoolOpt false "${namespace}.config.locale.enable";
  };

  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = "en_CA.UTF-8";
    };
    time.timeZone = "America/Toronto";
  };
}