{ config, pkgs, flake-inputs, ... }:

{
  imports =[
      ./hardware-configuration.nix

      ../../apps/steam.nix

      ../../services/networking/networkmanager.nix
      ../../services/networking/iwd.nix
    ];

  networking.hostName = "Burke";
  home-manager.users.adam = import "${flake-inputs.self}/modules/home-config/hosts/Burke.nix";

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "adamz";

  system.stateVersion = "25.05"; # Did you read the comment?

}
