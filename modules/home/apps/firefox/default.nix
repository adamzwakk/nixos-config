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
    cfg = config.${namespace}.apps.firefox;
  in
  {
    options.${namespace}.apps.firefox = with types; {
      enable = mkBoolOpt false "Enable Firefox";
    };

    config = mkIf cfg.enable {
      programs = {
        firefox = {
          enable = true;

          profiles = {
            default = {
              id = 0;

              extensions.packages =
                with pkgs.nur.repos.rycee.firefox-addons; ### https://nur.nix-community.org/repos/rycee/
                [
                  auto-tab-discard
                  clearurls
                  localcdn
                  react-devtools
                  remove-youtube-s-suggestions
                  sponsorblock
                  ublock-origin
                  umatrix
                  youtube-high-definition
                ];
              settings = {
                "app.normandy.enabled" = false;
                "app.shield.optoutstudies.enabled" = false;

                "extensions.pocket.enabled" = lock-false;
                "browser.policies.runOncePerModification.displayBookmarksToolbar" = "newtab";
                "browser.contentblocking.category" = "standard"; # "strict"

                "browser.shell.checkDefaultBrowser" = lock-false;

                "browser.newtabpage.activity-stream.showSponsored" = lock-false;
                "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
                "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;

                # disable new data submission
                "datareporting.policy.dataSubmissionEnabled" = lock-false;
                # disable Health Reports
                "datareporting.healthreport.uploadEnabled" = lock-false;
                # 0332: disable telemetry

                "privacy.donottrackheader.enabled" = true;
                "privacy.trackingprotection.enabled" = true;
                "privacy.trackingprotection.socialtracking.enabled" = true;

                "toolkit.telemetry.unified" = lock-false;
                "toolkit.telemetry.enabled" = lock-false;
                "toolkit.telemetry.server" = "data:,";
                "toolkit.telemetry.archive.enabled" = lock-false;
                "toolkit.telemetry.newProfilePing.enabled" = lock-false;
                "toolkit.telemetry.shutdownPingSender.enabled" = lock-false;
                "toolkit.telemetry.updatePing.enabled" = lock-false;
                "toolkit.telemetry.bhrPing.enabled" = lock-false;
                "toolkit.telemetry.firstShutdownPing.enabled" = lock-false;
                # disable Telemetry Coverage
                "toolkit.telemetry.coverage.opt-out" = true; # [HIDDEN PREF]
                "toolkit.coverage.opt-out" = true; # [FF64+] [HIDDEN PREF]
                "toolkit.coverage.endpoint.base" = "";
                # disable PingCentre telemetry (used in several System Add-ons) [FF57+]
                "browser.ping-centre.telemetry" = lock-false;
                # disable Firefox Home (Activity Stream) telemetry
                "browser.newtabpage.activity-stream.feeds.telemetry" = lock-false;
                "browser.newtabpage.activity-stream.telemetry" = lock-false;
                "toolkit.telemetry.reportingpolicy.firstRun" = lock-false;
                "toolkit.telemetry.shutdownPingSender.enabledFirstsession" = lock-false;
                "browser.vpn_promo.enabled" = lock-false;
              };
            };
          };
        };
      };
    };
}