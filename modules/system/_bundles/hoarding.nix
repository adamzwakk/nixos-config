{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
{

  users.groups.hoarding = {};

  sops.secrets."sabnzbd/server".owner = config.services.sabnzbd.user;
  sops.secrets."sabnzbd/user".owner = config.services.sabnzbd.user;
  sops.secrets."sabnzbd/password".owner = config.services.sabnzbd.user;

  services.sabnzbd = {
    enable = true;
    openFirewall = true;
    group = "hoarding";
    configFile = null;
    settings = {
      misc = {
        port = 8123;
        bandwidth_max = "10MB/s";
        bandwidth_perc = 80;
      };
      servers.newsgroup-ninja = {
        name = "newsgroup-ninja";
        displayname = "Newsgroup Ninja";
        host = "@sab_server@";
        port = 563;
        connections = 20;
        ssl = true;
        priority = 0;
        username = "@sab_username@";
        password = "@sab_password@";
        expire_date = null;
      };
    };

    secretValues = {
      "@sab_server@" = config.sops.secrets."sabnzbd/server".path;
      "@sab_username@" = config.sops.secrets."sabnzbd/user".path;
      "@sab_password@" = config.sops.secrets."sabnzbd/password".path;
    };
  };
}