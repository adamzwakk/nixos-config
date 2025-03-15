{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.direnv;
  user = config.${namespace}.config.user;
in
{
  options.${namespace}.tools.direnv = with types; {
    enable = mkBoolOpt false "${namespace}.tools.direnv.enable";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };
}