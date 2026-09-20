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
    
    # Yes this has an optical drive
    ../../_bundles/optical.nix

    ../../apps/steam.nix
    ../../apps/vuescan.nix
    # ../../apps/vr.nix

    ../../services/networking/networkmanager.nix
    ../../services/networking/work-vpn.nix
    # ../../services/networking/avahi.nix
  ];

  lv426 = {
    
    desktop = {
      #hyprland.enable = true;
      niri.enable = true;
      noctalia.enable = true;
    };
    services = {

      #hyprlock.enable = true;

      greetd = {
        enable = true;
        default = "niri-session";
      };

      docker.enable = true;
    };

    system = {
      audio.enable = true;
      secure_boot.enable = true;
    };

    # hoarding = {
    #   usenet.enable = true;
    #   #transmission.enable = true;
    #   downloadBaseDir = "/srv/hoarding";
    # };
  };

  networking.hostName = "ZwakkTower";
  home-manager.users.adam = import "${flake-inputs.self}/modules/home-config/hosts/ZwakkTower.nix";

  fileSystems."/boot".options = [ "fmask=0077" "dmask=0077" ];

  fileSystems = 
    let 
      smb_automount_opts = ["x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
      hudson_dir = "10.100.1.12:/mnt/Hudson";
      nfs_options = [ "x-systemd.automount" "noauto" ];
    in
    {
    "/mnt/Projects" = {
      device = "${hudson_dir}/Adam/Projects";
      fsType = "nfs";
      options = nfs_options;
    };
    "/mnt/Adam" = {
      device = "${hudson_dir}/Adam";
      fsType = "nfs";
      options = nfs_options;
    };
    "/mnt/Torrents" = {
      device = "${hudson_dir}/Downloads/Torrents";
      fsType = "nfs";
      options = nfs_options;
    };
    "/mnt/Hoarding" = {
      device = "${hudson_dir}/Hoarding";
      fsType = "nfs";
      options = nfs_options;
    };

    ## SMB Shares
    "/mnt/Media" = {
      device = "//10.100.1.12/Media";
      fsType = "cifs";
      options = smb_automount_opts;
    };
    "/mnt/Games" = {
      device = "//10.100.1.12/Games";
      fsType = "cifs";
      options = smb_automount_opts;
    };
  };
}
