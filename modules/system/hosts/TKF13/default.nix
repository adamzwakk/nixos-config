{
  pkgs,
  lib,
  flake-inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../apps/steam.nix

    ../../services/networking/iwd.nix
  ];

  networking.hostName = "TKF13";
  home-manager.users.adam = import "${flake-inputs.self}/modules/home-config/hosts/TKF13.nix";

  fileSystems = {
    "/mnt/Projects" = {
      device = "10.100.1.12:/mnt/Hudson/Adam/Projects";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };
  };
}
