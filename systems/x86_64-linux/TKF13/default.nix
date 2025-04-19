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

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    # bootloader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
  };

  networking = {
    hostName = "TKF13";
    useDHCP = lib.mkDefault true;
    firewall.enable = true;
  };

  services.tlp = { enable = mkForce false; };
  lv426 = {
    config = {
      user = {
        name = "adam";
        fullName = "Adam Zwakenberg";
        email = "adam@adamzwakk.com";
        extraGroups = [ "wheel" "docker" "networkmanager" "kvm" ];
      };
      nix = enabled;
    };
    bundles = {
      common = enabled;
    };

    desktop = {
      # kde = enabled;
      hyprland = enabled;
    };

    gaming = {
      steam = enabled;
    };

    services = {
      syncthing = enabled;
      #virtualization = enabled;
    };

  };

  services.fwupd.enable = true;

  # NFS Shares
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
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
