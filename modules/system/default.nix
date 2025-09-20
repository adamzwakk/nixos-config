{
  config,
  pkgs,
  lib,
  flake-inputs,
  ...
}:
with lib;
{
  imports = [
    flake-inputs.home-manager.nixosModules.home-manager
    flake-inputs.sops-nix.nixosModules.sops
    flake-inputs.stylix.nixosModules.stylix

    ./desktop
    ../lv426/options.nix
  ];

  nix = {
    package = pkgs.nixVersions.latest;

    gc = {
      options = "--delete-older-than 30d";
      dates = "daily";
      automatic = true;
    };

    settings = {
      trusted-users = ["adam"];
      sandbox = "relaxed";
      auto-optimise-store = true;
      allowed-users = ["adam" "music"];             # My god it took me hours to realize you need the user here for home manager to work
      experimental-features = "nix-command flakes";
      http-connections = 50;
      warn-dirty = false;
      log-lines = 50;
    };
    # TODO: flake-utils-plus
    # generateRegistryFromInputs = true;
    # generateNixPathFromInputs = true;
    # linkInputs = true;
  };

  sops = {
    defaultSopsFile = "${flake-inputs.self}/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";

    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };
  
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ 
      flake-inputs.nur.overlays.default
      flake-inputs.rust-overlay.overlays.default
    ];
  };

  boot = {
    tmp.cleanOnBoot = true;
    kernelModules = [ "kvm-amd" "sg"];
    kernel.sysctl = { "vm.swappiness" = 20; };
    kernelPackages = pkgs.linuxPackages_zen;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  time.timeZone = lib.mkDefault "America/Toronto";

  i18n = {
    defaultLocale = "en_CA.UTF-8";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit flake-inputs;
      nmEnabled = config.networking.networkmanager.enable;  # Determine if we're using nm or not
      lv426 = config.lv426;
    };
  };

  users = {
    defaultUserShell = pkgs.bash;
    users = {
      adam = { # I always exists, I am always here
        isNormalUser = true;
        initialPassword = "password";
        shell = pkgs.bash;
        extraGroups = [
          "wheel"
          "video"
          "kvm"
        ] 
        ++ lib.optionals config.networking.networkmanager.enable [
          "networkmanager"
        ]
        ++ lib.optionals config.programs.adb.enable [
          "adbusers"
        ]
        ++ lib.optionals config.virtualisation.docker.enable [
          "docker"
        ];
      };
    };
  };

  documentation.man.generateCaches = true;

  fileSystems."/boot".options = [ "fmask=0077" "dmask=0077" ];

  fonts = {
    enableDefaultPackages = true;
    fontDir = {
      enable = true;
    };
    fontconfig = {
      enable = true;
      defaultFonts = {
        # monospace = [ "0xProto Nerd Font" ];
        # sansSerif = [ "0xProto Nerd Font" ];
        # serif = [ "0xProto Nerd Font" ];
      };
    };
    packages = with pkgs; [
      nerd-fonts._0xproto
    ];
  };

  systemd = {
    # My systems never have usable root accounts anyway, so emergency
    # mode just drops into a shell telling me it can't log into root
    enableEmergencyMode = false;
    #services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
  };

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    udisks2.enable = true;
    fwupd.enable = true;
    automatic-timezoned.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    firewall.enable = true;

    extraHosts = lib.mkAfter ''
      0.0.0.0 apresolve.spotify.com
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      nano
      git
      gnumake
      openssl
      nh
      wget
      rar
      pavucontrol
      brightnessctl        # Screen/laptop brightness
      playerctl            # Get music metadata from media players
      killall
      p7zip
      fzf                  # Fuzzy Finder
      jq                   # Better JSON parsing

      htop
      nvtopPackages.amd    # GPU Top for AMD
      fastfetch            # System stats fetching
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb
    ];

    sessionVariables = {
      NIXOS_CONFIG = "/home/adam/pj/nixos-config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
      # To prevent firefox from creating ~/Desktop.
      XDG_DESKTOP_DIR = "$HOME";
      EDITOR = "nano";
      BROWSER = "firefox";
      TERMINAL = "alacritty";

      NIXOS_OZONE_WL = "1";
    };
    variables = {
      # Make some programs "XDG" compliant.
      LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
      LESSKEY = "$XDG_CACHE_HOME/less/lesskey";
      WGETRC = "$XDG_CONFIG_HOME/wgetrc";
    };
  };


  system.stateVersion = "25.05";
}