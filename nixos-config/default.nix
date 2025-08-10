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
    defaultSopsFile = "${../../../secrets/secrets.yaml}";
    defaultSopsFormat = "yaml";

    age = {
      generateKey = true;
      keyFile = "/home/adam/.config/sops/age/keys.txt";
      sshKeyPaths = [ "/home/adam/.ssh/id_ed25519" ];
    };

    secrets = {
      "private_keys/adam" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
    };
  };
  
  nixpkgs.overlays = [ 
    flake-inputs.nur.overlays.default
    flake-inputs.rust-overlay.overlays.default
  ];

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/brewer.yaml"; #https://tinted-theming.github.io/tinted-gallery/
    opacity = {
      terminal = 0.8;
      desktop = 0.5;
    };
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

  users = {
    defaultUserShell = pkgs.bash;

    users = {
      adam = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" "networkmanager" "kvm" ];
      };
    };
  };

  documentation.man.generateCaches = true;

  environment = {
    systemPackages = with pkgs; [ pavucontrol ];

    extraInit = ''
      # Do not want this in the environment. NixOS always sets it and does not
      # provide any option not to, so I must unset it myself via the
      # environment.extraInit option.
      unset -v SSH_ASKPASS
    '';
  };

  programs = {
    git.enable = true;
    nano.enable = false;
    firefox.enable = true;
  };

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
    # nscd.enableNsncd = true;
    # blueman.enable = true;
    # chrony.enable = true;
    # flatpak.enable = true;
    # fstrim.enable = true;
    fwupd.enable = true;
    automatic-timezoned.enable = true;
  };

  hardware = {
    # bluetooth.enable = true;
    enableRedistributableFirmware = true;
    # opentabletdriver.enable = true;
  };

  networking = {
    networkmanager.enable = true;
  };

  system.stateVersion = "25.05";
}