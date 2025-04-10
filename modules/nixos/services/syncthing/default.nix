{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
  let
    cfg = config.${namespace}.services.syncthing;
  in
  {
    options.${namespace}.services.syncthing = with types; {
      enable = mkBoolOpt false "Enable Syncthing";
    };

    config = mkIf cfg.enable {
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
        dataDir = "/home/adam/Syncthing";
        configDir = "/home/adam/.config/syncthing";
        user = "adam";
        group = "users";
        settings = {
          devices = {
            "Hudson" = { id = config.sops.secrets.syncthing-hudson-id.path; };
          };
          folders = {
            "chbzc-emukm" = {
              path = "/home/adam/Syncthing/KeePass";
              devices = [ "Hudson" ];
            };
            "ccjci-yo3ne" = {
              path = "/home/adam/Syncthing/Obsidian";
              devices = [ "Hudson" ];
            };
          };
        };
      };
      systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
    };
}