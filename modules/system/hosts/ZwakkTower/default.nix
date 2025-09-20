{
  pkgs,
  lib,
  config,
  flake-inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    
    ../../apps/k3b.nix
    ../../apps/steam.nix
    ../../apps/vuescan.nix

    ../../services/docker.nix
    ../../services/networking/networkmanager.nix
    ../../services/networking/work-vpn.nix
  ];

  lv426 = {
    desktop.hyprland.enable = true;
  };

  networking.hostName = "ZwakkTower";
  home-manager.users.adam = import "${flake-inputs.self}/modules/home-config/hosts/ZwakkTower.nix";

  # Yes this has an optical drive
  users.users.adam.extraGroups = [ "cdrom" ];

  fileSystems = 
    let 
      smb_automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      hudson_dir = "10.100.1.12:/mnt/Hudson";
    in
    {
    "/mnt/Projects" = {
      device = "${hudson_dir}/Adam/Projects";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };
    "/mnt/Adam" = {
      device = "${hudson_dir}/Adam";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };
    "/mnt/Torrents" = {
      device = "${hudson_dir}/Downloads/Torrents";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };
    "/mnt/Hoarding" = {
      device = "${hudson_dir}/Hoarding";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };

    ## SMB Shares
    "/mnt/Media" = {
      device = "//10.100.1.12/Media";
      fsType = "cifs";
      options = ["${smb_automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
    };
    "/mnt/Games" = {
      device = "//10.100.1.12/Games";
      fsType = "cifs";
      options = ["${smb_automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
    };
  };
}
