{
  options,
  config,
  lib,
  pkgs,
  flake-inputs,
  ...
}:
with lib;
{
  options.lv426.desktop.noctalia.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable noctalia";
  };

  config = mkIf config.lv426.desktop.noctalia.enable {

    environment.systemPackages = with pkgs; [
      flake-inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}