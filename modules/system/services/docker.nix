{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
{
  config = mkIf config.lv426.services.docker.enable {
    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    virtualisation = {
      docker.enable = true;
      docker.storageDriver = "btrfs";
      podman.enable = true;
    };
  };
}