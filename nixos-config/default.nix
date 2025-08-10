{
  config,
  pkgs,
  lib,
  flake-inputs,
  ...
}:
{
  imports = [
    flake-inputs.home-manager.nixosModules.home-manager
    flake-inputs.sops-nix.nixosModules.sops
    flake-inputs.stylix.nixosModules.stylix

    ./desktop
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
      allowed-users = ["adam"];
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
    defaultSopsFile = "${../secrets/secrets.yaml}";
    defaultSopsFormat = "yaml";

    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    
    secrets = {
      syncthing-hudson-id = {};
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
      nixos-config = config;
    };
  };

  users = {
    defaultUserShell = pkgs.bash;

    users = {
      adam = {
        initialPassword = "password";
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" "networkmanager" "kvm" ];
        shell = pkgs.bash;
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

  # My systems never have usable root accounts anyway, so emergency
  # mode just drops into a shell telling me it can't log into root
  systemd.enableEmergencyMode = false;

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

    udev.packages = [
      pkgs.android-udev-rules
    ];
  };

  hardware = {
    # bluetooth.enable = true;
    enableRedistributableFirmware = true;
    # opentabletdriver.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  environment.systemPackages = with pkgs; [
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

    htop
    nvtopPackages.amd    # GPU Top for AMD
    fastfetch            # System stats fetching
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  system.stateVersion = "25.05";
}