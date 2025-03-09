{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.git;
  user = config.${namespace}.config.user;
in
{
  options.${namespace}.tools.git = with types; {
    enable = mkBoolOpt false "${namespace}.tools.git.enable";
    username = mkOpt str user.fullName "${namespace}.tools.git.username";
    useremail = mkOpt str user.email "${namespace}.tools.git.useremail";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      delta = enabled;
      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "main";
        rebase.autoStash = true;
      };
      lfs = enabled;
      userEmail = cfg.useremail;
      userName = cfg.username;
    };
  };
}