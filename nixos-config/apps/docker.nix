{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
{
  environment.systemPackages = with pkgs; [
      distrobox
      docker-compose
    ];

    virtualisation = {
      docker.enable = true;
      docker.storageDriver = "btrfs";
      podman.enable = true;
    };
}