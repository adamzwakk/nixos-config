{
  options,
  lib,
  config,
  pkgs,
  lv426,
  ...
}:
with lib;
{
  options.lv426.apps.rss.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable rss reader";
  };

  config = mkIf config.lv426.apps.rss.enable {
    
    programs.newsboat = {
      enable = true;
      autoReload = true;
      maxItems = 20;
      urls = [
        {url = "https://linuxiac.com/feed/"; tags = ["linux"];}
        {url = "https://www.gamingonlinux.com/article_rss.php"; tags = ["linux" "gaming"];}
        {url = "https://nixos.org/blog/announcements-rss.xml"; tags = ["linux"];}
      ];
    };
  };
}