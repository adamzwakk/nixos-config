{
  pkgs,
  lib,
  flake-inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix

    ../../apps/steam.nix

    ../../services/networking/iwd.nix
  ];

  lv426 = {
    
    desktop = {
      niri.enable = true;
      noctalia.enable = true;
    };
    services = {
      greetd = {
        enable = true;
        default = "niri-session";
      };

      docker.enable = true;
    };

    system = {
      audio.enable = true;
      #secure_boot.enable = true;
    };

    # hoarding = {
    #   usenet.enable = true;
    #   #transmission.enable = true;
    #   downloadBaseDir = "/srv/hoarding";
    # };
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
