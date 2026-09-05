{
  options,
  config,
  lib,
  pkgs,
  flake-inputs,
  ...
}:
with lib;
let
  sabClient = {
    name = "SABnzbd";
    implementation = "Sabnzbd";
    fields = {
      host = "localhost";
      port = sabnzbdPort;
      useSsl = false;
      apiKey.secret = config.sops.secrets."sabnzbd/api_key".path;
    };
  };

  sabnzbdPort = 8123;
  prowlarrPort = 8124;
  radarrPort = 8125;
  sonarrPort = 8126;
in
{
  options.lv426.hoarding.usenet.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable Usenet hoarding stuff";
  };

  imports = [
    flake-inputs.nixarr.nixosModules.default
  ];

  config = mkIf config.lv426.hoarding.usenet.enable {

    users.groups.sabnzbd-api = { };
    sops.secrets."sabnzbd/server".owner = config.services.sabnzbd.user;
    sops.secrets."sabnzbd/user".owner = config.services.sabnzbd.user;
    sops.secrets."sabnzbd/password".owner = config.services.sabnzbd.user;
    sops.secrets."sabnzbd/api_key" = {
      owner = config.services.sabnzbd.user;
      group = "sabnzbd-api";
      mode = "0440";
    };

    sops.secrets."usenet_indexers/nzbgeek".owner = "prowlarr";
    sops.secrets."usenet_indexers/dognzb".owner = "prowlarr";

    nixarr = {
      enable = true;
      mediaDir = "${config.lv426.hoarding.downloadBaseDir}";

      sabnzbd = {
        enable = true;
        guiPort = sabnzbdPort;
        openFirewall = true;
      };

      prowlarr = {
        enable = true;
        port = prowlarrPort;
        openFirewall = true;

        settings-sync = {
          enable-nixarr-apps = true;
          indexers = [
            {
              sort_name = "nzbgeek";
              fields.apiKey.secret = config.sops.secrets."usenet_indexers/nzbgeek".path;
            }
            {
              sort_name = "dognzb";
              fields.apiKey.secret = config.sops.secrets."usenet_indexers/dognzb".path;
            }
          ];
        };
      };
      
      radarr = {
        enable = true;
        port = radarrPort;
        openFirewall = true;

        settings-sync.downloadClients = [sabClient];
      };

      sonarr = {
        enable = true;
        port = sonarrPort;
        openFirewall = true;

        settings-sync.downloadClients = [sabClient];
      };
    };

    services.sabnzbd = {
      configFile = null;
      allowConfigWrite = false;
      settings = {
        misc = {
          bandwidth_max = "10MB/s";
          bandwidth_perc = 80;
          api_key = "@sab_api@";
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
        "@sab_api@" = config.sops.secrets."sabnzbd/api_key".path;
      };
    };
    systemd.services.sabnzbd.serviceConfig.UMask = "0002";
    systemd.tmpfiles.rules = [
      "d ${config.lv426.hoarding.downloadBaseDir}                 2775 root    media - -"
    ];

    users.users.radarr.extraGroups = [ "sabnzbd-api" ];
    users.users.sonarr.extraGroups = [ "sabnzbd-api" ];

    services.prowlarr.settings.auth.required = "DisabledForLocalAddresses";
    services.radarr.settings.auth.required = "DisabledForLocalAddresses";
    services.sonarr.settings.auth.required = "DisabledForLocalAddresses";
  };
}