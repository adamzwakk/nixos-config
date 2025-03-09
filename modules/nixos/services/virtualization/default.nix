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
  cfg = config.${namespace}.services.virtualization;
in
{
  options.${namespace}.services.virtualization = with types; {
    enable = mkBoolOpt false "Enable virtualisation";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      distrobox
      bottles
      docker-compose
    ];

    virtualisation = {
      docker.enable = true;
      docker.storageDriver = "btrfs";
      podman.enable = true;
    };
  };
}