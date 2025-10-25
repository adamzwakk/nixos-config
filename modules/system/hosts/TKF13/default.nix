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

  lv426 = {
    desktop.hyprland.enable = true;
    services = {
      hyprlock.enable = true;

      greetd = {
        enable = true;
        default = "hyprland";
      };
      
      docker.enable = true;
    };
  };

  networking.hostName = "TKF13";
  home-manager.users.adam = import "${flake-inputs.self}/modules/home-config/hosts/TKF13.nix";
  virtualisation.docker.storageDriver = lib.mkForce null;

  fileSystems = {
    "/mnt/Projects" = {
      device = "10.100.1.12:/mnt/Hudson/Adam/Projects";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };
  };
}
