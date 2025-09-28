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
  options.lv426.services.docker.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable docker";
  };

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