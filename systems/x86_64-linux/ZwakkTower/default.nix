{ pkgs, config, lib, ... }:
with lib;
with lib.lv426;
let
  newUser = name: {
    isNormalUser = true;
    createHome = true;
    home = "/home/${name}";
    shell = pkgs.bash;
  };
in {
  imports = [ ./hardware.nix ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ZwakkTower";
  networking.firewall.enable = true;

  services.tlp = { enable = mkForce false; };
  lv426 = {
    config = {
      user = {
        name = "adam";
        fullName = "Adam Zwakenberg";
        email = "adam@adamzwakk.com";
        extraGroups = [ "wheel" "docker" "networkmanager" "kvm" "input" ];
        ## Needed input for keychron flashing reasons https://www.reddit.com/r/Keychron/comments/1e5um1u/a_linux_user_psa/
      };
      nix = enabled;
    };
    bundles = {
      common = enabled;
    };

    desktop = {
      #kde = enabled;
      hyprland = enabled;
    };

    gaming = {
      steam = enabled;
    };

    services = {
      flatpak = enabled;
      ollama = enabled;
      # sunshine = enabled;
      syncthing = enabled;
      virtualization = enabled;
    };

  };

  services.udev.packages = [ pkgs.lv426.vuescan ];

  # NFS Shares
  fileSystems."/mnt/Projects" = {
    device = "10.100.1.12:/mnt/Hudson/Adam/Projects";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };
  fileSystems."/mnt/Adam" = {
    device = "10.100.1.12:/mnt/Hudson/Adam";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };
  fileSystems."/mnt/Torrents" = {
    device = "10.100.1.12:/mnt/Hudson/Downloads/Torrents";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };

  fileSystems."/mnt/Media" = {
    device = "//10.100.1.12/Media";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
  };

  fileSystems."/mnt/Games" = {
    device = "//10.100.1.12/Games";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
