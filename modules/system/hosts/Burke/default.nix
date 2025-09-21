{ config, pkgs, ... }:

{
  imports =[
      ./hardware-configuration.nix

      ../../apps/steam.nix

      ../../services/networking/networkmanager.nix
      ../../services/networking/iwd.nix
    ];

  networking.hostName = "Burke"; # Define your hostname.

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "adamz";

  # Install firefox.
  programs.firefox.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
