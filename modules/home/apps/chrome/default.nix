{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
  let
    cfg = config.${namespace}.apps.chrome;
  in
  {
    options.${namespace}.apps.chrome = with types; {
      enable = mkBoolOpt false "Enable Chrome";
    };

    config = mkIf cfg.enable {
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