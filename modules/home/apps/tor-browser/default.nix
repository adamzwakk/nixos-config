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
    cfg = config.${namespace}.apps.tor;
  in
  {
    options.${namespace}.apps.tor = with types; {
      enable = mkBoolOpt false "Enable Tor";
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [ 
        tor-browser
      ];
    };
}