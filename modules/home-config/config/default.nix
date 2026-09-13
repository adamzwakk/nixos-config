{
  lib,
  config,
  pkgs,
  flake-inputs,
  ...
}:
let
  d = "${config.home.homeDirectory}/.local/share";
  c = "${config.home.homeDirectory}/.config";
  cache = "${config.home.homeDirectory}/.cache";
in
{
  imports = [
    flake-inputs.sops-nix.homeManagerModules.sops
    flake-inputs.stylix.homeModules.stylix
    #flake-inputs.nixvim.homeModules.nixvim

    ./desktop
    ./apps
    ./services
  ];

  sops = {
    defaultSopsFile = "${flake-inputs.self}/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";

    age = {
      generateKey = true;
      keyFile = "${c}/sops/age/keys.txt";
      sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    };

    secrets = {
      "private_keys/adam" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
    };
  };

  stylix = {
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/brewer.yaml"; #https://tinted-theming.github.io/tinted-gallery/
    opacity = {
      terminal = 0.8;
      desktop = 0.5;
    };
    targets = {     
      gtk.enable = true;
      qt.enable = true;
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
  };

  services.ssh-agent.enable = true;

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
      ni = "nh os switch -a ${config.home.homeDirectory}/pj/nixos-config"; ## Install NixOS Config without updating flake
      nt = "nh os test -a ${config.home.homeDirectory}/pj/nixos-config"; ## Test NixOS Config without updating flake

      rbwin = "systemctl reboot --boot-loader-entry=auto-windows"; ## Reboot into Windows

      # Replacemments
      top = "htop";

      # Common arguments
      ll = "ls -l";
    };
  }; 
}