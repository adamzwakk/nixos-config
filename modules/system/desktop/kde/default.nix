{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.lv426.desktop.kde.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable KDE as the desktop environment";
  };

  config = mkIf config.lv426.desktop.kde.enable {
    services = {
      desktopManager.plasma6.enable = true;
    };

    # security.pam.services.sddm.enableKwallet = true; ## For keyring hopefully? if no kde maybe I should use GNOME one tho

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      okular
      krdp
      gwenview
    ];
  };
}