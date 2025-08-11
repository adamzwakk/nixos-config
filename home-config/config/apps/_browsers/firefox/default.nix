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
              remove-youtube-s-suggestions
              sponsorblock
              ublock-origin
              umatrix
              youtube-high-definition
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

              ## Remove Youtube Suggestions
              "{21f1ba12-47e1-4a9b-ad4e-3a0260bbeb26}".settings = {
                global_enable = true;
                dark_mode = false;
                log_enabled = true;
                nextTimedChange = false;
                nextTimedValue = true;
                schedule = false;
                remove_all_shorts = true;
                remove_video_thumbnails = false;
                blur_video_thumbnails = false;
                shrink_video_thumbnails = false;
                disable_play_on_hover = false;
                search_engine_mode = false;
                remove_homepage = false;
                remove_sidebar = true;
                remove_end_of_video = true;
                add_reveal_button = false;
                remove_header = false;
                remove_all_but_one = false;
                remove_extra_rows = false;
                remove_infinite_scroll = false;
                remove_left_nav_bar = true;
                only_show_playlists = false;
                remove_logo_link = false;
                remove_home_link = false;
                remove_explore_link = false;
                remove_shorts_link = false;
                remove_subscriptions_link = false;
                remove_quick_links_section = false;
                remove_sub_section = false;
                remove_explore_section = false;
                remove_more_section = false;
                remove_settings_section = false;
                remove_footer_section = false;
                auto_skip_ads = false;
                disable_autoplay = true;
                disable_ambient_mode = true;
                disable_annotations = false;
                expand_description = false;
                disable_playlist_autoplay = false;
                disable_fullscreen_scroll = false;
                normalize_shorts = false;
                remove_info_cards = false;
                remove_overlay_suggestions = true;
                remove_play_next_button = false;
                remove_menu_buttons = false;
                remove_clip_button = false;
                remove_video_likes = false;
                remove_channel_subscribers = false;
                remove_vid_description = false;
                remove_embedded_more_videos = true;
                remove_entire_sidebar = true;
                remove_sidebar_infinite_scroll = false;
                remove_extra_sidebar_tags = false;
                remove_chat = false;
                remove_comments = false;
                remove_non_timestamp_comments = false;
                remove_comment_usernames = false;
                remove_comment_profiles = false;
                remove_comment_replies = false;
                remove_comment_upvotes = false;
                remove_search_suggestions = false;
                remove_search_promoted = true;
                remove_shorts_results = false;
                remove_extra_results = false;
                remove_thumbnail_mouseover_effect = false;
                remove_infinite_scroll_search = false;
                disable_channel_autoplay = false;
                remove_channel_for_you = false;
                reverse_channel_video_list = false;
                remove_sub_shorts = false;
                remove_sub_live = false;
                remove_sub_upcoming = false;
                remove_sub_premiere = false;
                remove_sub_vods = false;
                redirect_to_subs = false;
                redirect_to_wl = false;
                redirect_to_library = false;
                redirect_off = true;
                remove_playlist_suggestions = false;
                remove_notif_bell = false;
                autofocus_search = false;
                remove_context = false;
                grayscale_mode = false;
                menu_timer = false;
                lock_code = false;
              };
            };
          };
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