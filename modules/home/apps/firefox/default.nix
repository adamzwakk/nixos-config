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

          policies = {
            DisablePocket = true;
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
              Value= true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            DontCheckDefaultBrowser = true;
            DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"

            Preferences = { 
              "extensions.pocket.enabled" = lock-false;

              "browser.newtabpage.activity-stream.showSponsored" = lock-false;
              "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
            };
          };
        };
      };
    };
}