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
      udisks2.enable = true;
    };
    lv426 = {
      config.nix = enabled;

      hardware = {
        audio = enabled;
        networking = enabled;
      };

      services = {
        sddm = enabled;
      };

      system = {
        # fonts = enabled;
        locale = enabled;
        env = enabled;
      };
    };

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
      opacity.terminal = 0.9;
    };

    environment.systemPackages = with pkgs; [
      neovim
      git
      gnumake
      openssl
      nh
      wget
      rar
      bat

      htop
      fastfetch
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

    ## Add something to ALL envs
    # programs.bash.interactiveShellInit = ''
    #   switch () {
    #     nh os switch --update ~/pj/nixos-config ;
    #   }
    # '';
  };
}