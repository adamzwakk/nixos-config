{
  options,
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.networking;
in
{
  options.${namespace}.hardware.networking = with types; {
    enable = mkBoolOpt false "Enable networkmanager";
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      extraHosts = 
        ''
          0.0.0.0 apresolve.spotify.com   # https://github.com/librespot-org/librespot/issues/1527#issuecomment-3168055538
        '';
    };
  };
}