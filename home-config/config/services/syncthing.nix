{
  config,
  ...
}:
{
  services.syncthing = {
    enable = true;
    
    settings = {
      options = {
        urAccepted = -1;
      };

      devices.Hudson.id = "BVIX3HR-CIBWNUR-TNI2OWD-6OUC7H4-NII3XNU-Z3E6GA7-VNG5N3F-3DBPYQ3";
      folders = {
        "ccjci-yo3ne" = {
          id = "ccjci-yo3ne";
          label = "Obsidian";
          path = "${config.home.homeDirectory}/Syncthing/Obsidian";
          devices = [ "Hudson" ];
        };
      };
    };
  };
}