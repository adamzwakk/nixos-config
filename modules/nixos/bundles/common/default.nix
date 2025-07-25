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
let
  cfg = config.${namespace}.bundles.common;
in
{
  options.${namespace}.bundles.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    services = {
      udisks2.enable = true;      # Automounting USB drives
    };
    lv426 = {
      config.nix = enabled;

      hardware = {
        audio = enabled;
        networking = enabled;
      };

      system = {
        # fonts = enabled;
        locale = enabled;
        env = enabled;
      };

      security.sops = enabled;
    };

    environment.systemPackages = with pkgs; [
      nano
      git
      gnumake
      openssl
      nh
      wget
      rar
      bat                  # A better cat
      bat-extras.batman    # bat but for man pages
      brightnessctl        # Screen/laptop brightness
      playerctl            # Get music metadata from media players
      killall
      p7zip
      fzf                  # Fuzzy Finder
      yazi                 # File Manager
      eza                  # A 'better' ls

      htop
      nvtopPackages.amd    # GPU Top for AMD
      fastfetch            # System stats fetching
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb
    ];

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

    #services.gnome.gnome-keyring.enable = true;
    programs.ssh.startAgent = true;

    ## Needed to use android adb stuff
    services.udev.packages = [
      pkgs.android-udev-rules
    ];

    ## Add something to ALL envs
    # programs.bash.interactiveShellInit = ''
    #   switch () {
    #     nh os switch --update ~/pj/nixos-config ;
    #   }
    # '';
  };
}