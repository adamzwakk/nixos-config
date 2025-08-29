{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    
    dataDir = "/home/adam/Syncthing";
    configDir = "/home/adam/.config/syncthing";
    user = "adam";
    group = "users";
    settings = {
      devices.Hudson.id = "BVIX3HR-CIBWNUR-TNI2OWD-6OUC7H4-NII3XNU-Z3E6GA7-VNG5N3F-3DBPYQ3";

      folders = {
        "ccjci-yo3ne" = {
          id = "ccjci-yo3ne";
          label = "Obsidian";
          path = "/home/adam/Syncthing/Obsidian";
          devices = [ "Hudson" ];
        };
      };
    };
  };
  
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
}