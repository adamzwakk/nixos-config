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
    cfg = config.${namespace}.services.sunshine;
  in
  {
    options.${namespace}.services.sunshine = with types; {
      enable = mkBoolOpt false "Enable Sunshine";
    };

    config = mkIf cfg.enable {
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true; 
      };
    };
}