{
  lib,
  config,
  pkgs,
  flake-inputs,
  ...
}:
let
  d = "~/.local/share";
  c = "~/.config";
  cache = "~/.cache";
in
{
  imports = [
    flake-inputs.sops-nix.homeManagerModules.sops
    flake-inputs.stylix.homeModules.stylix
    flake-inputs.nixvim.homeModules.nixvim
  ];

  sops = {
    defaultSopsFile = "${../../secrets/secrets.yaml}";
    defaultSopsFormat = "yaml";

    age = {
      generateKey = true;
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    };

    secrets = {
      "private_keys/adam" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/brewer.yaml"; #https://tinted-theming.github.io/tinted-gallery/
    opacity = {
      terminal = 0.8;
      desktop = 0.5;
    };
  };

  programs = {
    bash.enable = true;

    git = {
      enable = true;
      delta.enable = true;
      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "main";
        rebase.autoStash = true;
      };
      lfs.enable = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    alacritty = {
      enable = true;
      settings = {
        window = {
          #opacity = 0.9;
          dynamic_padding = true;
          decorations = "None";
          padding.x = 5;
          padding.y = 5;
        };
      };
    };

    imv = {
      enable = true;
      settings = { ## https://manpages.ubuntu.com/manpages/lunar/man5/imv-x11.5.html
        options.overlay = true;
      };
    };
  };

  home = {
    sessionVariables = {
      # clean up ~
      LESSHISTFILE = cache + "/less/history";
      LESSKEY = c + "/less/lesskey";
      WINEPREFIX = d + "/wine";

      # set default applications
      EDITOR = "nano";
      BROWSER = "firefox";
      TERMINAL = "alacritty";

      # enable scrolling in git diff
      DELTA_PAGER = "less -R";

      # MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANPAGER = "less";
    };

    shellAliases = {
      # Helpful aliases
      nr = "nh os switch -a --update ${config.home.homeDirectory}/pj/nixos-config"; ## Rebuild NixOS Config

      # Replacemments
      top = "htop";

      # Common arguments
      ll = "ls -l";
    };
  }; 
}