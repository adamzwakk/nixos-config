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

    ./apps/bitwarden.nix
    ./apps/discord.nix
  ];

  sops = {
    defaultSopsFile = "${flake-inputs.self}/secrets/secrets.yaml";
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

    delta.enable = true;

    git = {
      enable = true;

      settings = {
        pull.rebase = true;
        init.defaultBranch = "main";
        rebase.autoStash = true;

        github.user = "adamzwakk";

        user = {
          name = "adamzwakk";
          email = "adam@adamzwakk.com";
        };
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

  services.syncthing.settings.folders = {
    "ccjci-yo3ne" = {
      id = "ccjci-yo3ne";
      label = "Obsidian";
      path = "${config.home.homeDirectory}/Syncthing/Obsidian";
      devices = [ "Hudson" ];
    };
  };

  home = {
    packages = with pkgs; [
      vscodium
      mpv

      yt-dlp
      obsidian
      gimp3
      obs-studio
      qbittorrent
      audacity
    ];
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