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
  cfg = config.${namespace}.rust;
in
{
  options.${namespace}.rust = with types; {
    enable = mkBoolOpt false "Enable rust";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
        (rust-bin.stable.latest.default.override {
          extensions = ["rust-src"];
        })
        rustup 
        gcc
      ];
  };
}