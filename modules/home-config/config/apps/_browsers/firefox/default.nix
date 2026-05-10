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

  ## IDEA FROM: https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265

  ## Ideas: https://github.com/xhos/nixdots/blob/5dcaeafc7106bdda21cafbd3b0c82471bdba940f/modules/home/opt/firefox/default.nix
  ##        https://github.com/TLATER/dotfiles/blob/master/home-config/config/applications/graphical/firefox.nix

  let
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
  in
  {
    programs.firefox = {
      enable = true;

      configPath = "${config.xdg.configHome}/mozilla/firefox";

      profiles = {
        "default" = {
          id = 0;
          isDefault = true;

          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [ ### https://nur.nix-community.org/repos/rycee/                  
              auto-tab-discard
              clearurls
              react-devtools
              sponsorblock
              ublock-origin
              umatrix
              youtube-high-definition
              lockedin-yt
              bitwarden
              firefox-color
            ];
            settings = {
              "uBlock0@raymondhill.net".settings = rec {
                importedLists = [
                  "https://big.oisd.nl"
                  "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                ];
                externalLists = lib.concatStringsSep "\n" importedLists;
                selectedFilterLists = [
                  "adguard-generic"
                  "adguard-annoyance"
                  "adguard-social"
                  "adguard-spyware-url"
                  "easylist"
                  "easyprivacy"
                  "plowe-0"
                  "ublock-abuse"
                  "ublock-badware"
                  "ublock-filters"
                  "ublock-privacy"
                  "ublock-quick-fixes"
                  "ublock-unbreak"
                  "urlhaus-1"
                ] ++ importedLists;
              };
            };
          };
          settings = {
            "app.normandy.enabled" = false;
            "app.shield.optoutstudies.enabled" = false;

            "extensions.pocket.enabled" = false;
            "browser.policies.runOncePerModification.displayBookmarksToolbar" = "newtab";
            "browser.contentblocking.category" = "standard"; # "strict"

            "browser.shell.checkDefaultBrowser" = false;

            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.system.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

            # disable new data submission
            "datareporting.policy.dataSubmissionEnabled" = false;
            # disable Health Reports
            "datareporting.healthreport.uploadEnabled" = false;
            # 0332: disable telemetry

            "privacy.donottrackheader.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;

            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            # disable Telemetry Coverage
            "toolkit.telemetry.coverage.opt-out" = true; # [HIDDEN PREF]
            "toolkit.coverage.opt-out" = true; # [FF64+] [HIDDEN PREF]
            "toolkit.coverage.endpoint.base" = "";
            # disable PingCentre telemetry (used in several System Add-ons) [FF57+]
            "browser.ping-centre.telemetry" = false;
            # disable Firefox Home (Activity Stream) telemetry
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            "toolkit.telemetry.shutdownPingSender.enabledFirstsession" = false;
            "browser.vpn_promo.enabled" = false;
          };
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "text/xml" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };

    stylix.targets.firefox = {
      enable = true;
      colorTheme.enable = true;
      profileNames = [ "default" ];
    };
  }