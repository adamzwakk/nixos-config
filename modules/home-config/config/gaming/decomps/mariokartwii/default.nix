{
  options,
  config,
  lib,
  pkgs,
  namespace,
  flake-inputs,
  ...
}:
{
  home.packages = with pkgs; [
    flake-inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.wheelwizard.default
  ];
}