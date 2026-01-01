{
  options,
  config,
  lib,
  pkgs,
  namespace,
  flake-inputs,
  ...
}:
let
  pkgs-stable = import flake-inputs.stable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  services.wivrn = {
    enable = true;
    openFirewall = true;

    #autoStart = true;

    steam.importOXRRuntimes = true;

    package = pkgs-stable.wivrn;
  };
}