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
    cfg = config.${namespace}.services.ollama;
  in
  {
    options.${namespace}.services.ollama = with types; {
      enable = mkBoolOpt false "Enable Ollama";
    };

    config = mkIf cfg.enable {
      services.ollama = {
        enable = true;
        acceleration = "rocm";
        rocmOverrideGfx = "11.0.0"; ## For the Radeon 7900 XTX
      };

      services.open-webui.enable = true;
    };
}