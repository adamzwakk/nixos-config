{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  sabnzbdPort = 8123;
  prowlarrPort = 8124;
in
{
  options.lv426.hoarding.usenet.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable Usenet";
  };

  config = mkIf config.lv426.hoarding.usenet.enable {

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
          port = sabnzbdPort;
          bandwidth_max = "10MB/s";
          bandwidth_perc = 80;
          download_dir = "${config.lv426.hoarding.downloadBaseDir}/Usenet/incomplete";
          complete_dir = "${config.lv426.hoarding.downloadBaseDir}/Usenet/complete";
          par2_multicore = true;

          permissions = "775";
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
    systemd.services.sabnzbd.serviceConfig.UMask = "0002";
    systemd.tmpfiles.rules = [
      "d ${config.lv426.hoarding.downloadBaseDir}                 2775 root    hoarding - -"
      "d ${config.lv426.hoarding.downloadBaseDir}/Usenet          2775 sabnzbd hoarding - -"
      "d ${config.lv426.hoarding.downloadBaseDir}/Usenet/incomplete 2775 sabnzbd hoarding - -"
      "d ${config.lv426.hoarding.downloadBaseDir}/Usenet/complete   2775 sabnzbd hoarding - -"
    ];

    services.prowlarr = {
      enable = true;
      openFirewall = true;

      settings = {
        server.port = prowlarrPort;
      };
    };
  };
}