{ config, lib, pkgs, flake-inputs, ... }:

{
  imports =[
    ./hardware-configuration.nix

    ../../apps/steam.nix

    ../../services/networking/networkmanager.nix
    ../../services/networking/iwd.nix
  ];

  lv426 = {
    desktop.kde.enable = true;
    services.sddm.enable = true;
  };

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest; # mostly debugging if intel arc needs lastest over zen

  networking.hostName = "Hicks";
  home-manager.users.adam = import "${flake-inputs.self}/modules/home-config/hosts/Hicks.nix";

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "adam";

  system.stateVersion = "25.05"; # Did you read the comment?

}
