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
    cfg = config.${namespace}.apps.bottles;
  in
  {
    options.${namespace}.apps.bottles = with types; {
      enable = mkBoolOpt false "Enable Bottles";
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [ 
        bottles
      ];
    };
}