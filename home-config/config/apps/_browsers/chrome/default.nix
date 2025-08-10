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
    cfg = config.${namespace}.apps._browsers.chrome;
  in
  {
    programs = {
      chromium = {
        enable = true;
        extensions = [
          # {id = "";}  // extension id, query from chrome web store
        ];
      };
    };
}