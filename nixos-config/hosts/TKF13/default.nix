{
  pkgs,
  lib,
  flake-inputs,
  ...
}:
{
  imports = [
    flake-inputs.nixos-hardware.nixosModules.framework-13-7040-amd 

    ./hardware-configuration.nix
    ../../apps/steam.nix

    ../../services/networking/iwd.nix
    ../../services/syncthing.nix

    # Extra Users
    ../../users/music.nix
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  networking.hostName = "TKF13";
  home-manager.users.adam = import "${flake-inputs.self}/home-config/hosts/adam@TKF13.nix";
  home-manager.users.music = import "${flake-inputs.self}/home-config/hosts/music@TKF13.nix";

  # For random android-related things
  programs.adb.enable = true;

  fileSystems = {
    "/mnt/Projects" = {
      device = "10.100.1.12:/mnt/Hudson/Adam/Projects";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };
  };
}
