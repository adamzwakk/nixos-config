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

    ../../services/networking/networkmanager.nix
    ../../services/networking/work-vpn.nix

    flake-inputs.lanzaboote.nixosModules.lanzaboote
  ];

  lv426 = {
    desktop.hyprland.enable = true;
    services.greetd.enable = true;
    services.docker.enable = true;
  };

  networking.hostName = "ZwakkTower";
  home-manager.users.adam = import "${flake-inputs.self}/modules/home-config/hosts/ZwakkTower.nix";

  ## Secure Boot Stuff
  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  ## End Secure Boot Stuff

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
