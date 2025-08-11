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
    ../../apps/syncthing.nix
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  networking.hostName = "ZwakkTower";
  home-manager.users.adam = import "${flake-inputs.self}/home-config/hosts/ZwakkTower.nix";

  # For random android-related things
  programs.adb.enable = true;
  users.users.adam.extraGroups = [ "adbusers" ];

  fileSystems = {
    "/mnt/Projects" = {
      device = "10.100.1.12:/mnt/Hudson/Adam/Projects";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };
    "/mnt/Adam" = {
      device = "10.100.1.12:/mnt/Hudson/Adam";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };
    "/mnt/Torrents" = {
      device = "10.100.1.12:/mnt/Hudson/Downloads/Torrents";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };

    ## SMB Shares
    "/mnt/Media" = {
      device = "//10.100.1.12/Media";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
    };
    "/mnt/Games" = {
      device = "//10.100.1.12/Games";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
    };
  };

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ nixpkgs.legacyPackages.x86_64-linux.epkowa ];
  services.udev.packages = [ flake-inputs.self.packages.${pkgs.system}.vuescan ];
  environment.systemPackages = [ 
    flake-inputs.self.packages.${pkgs.system}.vuescan
    flake-inputs.self.packages.${pkgs.system}.epson-v600-plugin 
  ];
  system.activationScripts.iscanPluginLibraries = ''
    mkdir -p /usr/share/iscan
    mkdir -p /usr/lib/iscan
    ln -sf ${flake-inputs.self.packages.${pkgs.system}.epson-v600-plugin}/share/iscan/* /usr/share/iscan
    ln -sf ${flake-inputs.self.packages.${pkgs.system}.epson-v600-plugin}/lib/iscan/* /usr/lib/iscan
  '';
}
