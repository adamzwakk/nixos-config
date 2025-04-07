{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-uuid/1106de9c-bf2e-47a8-b930-75b8f61d1286";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/boot" = { 
      device = "/dev/disk/by-uuid/9211-C5D7";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
    "/home" = { 
      device = "/dev/disk/by-uuid/32fa579d-3e34-4dee-940f-6b284bb803b6";
      fsType = "btrfs";
    };
  };

  swapDevices = [ 
    { device = "/dev/disk/by-uuid/42450461-4480-4b83-904a-36fc506b6102"; }
  ];

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };

    keyboard.qmk.enable = true;
    # bluetooth.enable = true; # enables support for Bluetooth
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  
  # networking.interfaces.br-c30a466668e6.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp14s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth78ed588.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth7dad7fb.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth8aaa8e0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp15s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
