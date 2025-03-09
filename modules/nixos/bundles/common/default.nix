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

      # services = {
      #   tailscale = enabled;
      # };

      system = {
        # fonts = enabled;
        locale = enabled;
        env = enabled;
      };
    };

    environment.systemPackages = with pkgs; [
      neovim
      git
      gnumake
      openssl
      nh
      wget
      rar

      htop
      fastfetch
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb
    ];

    programs.bash.interactiveShellInit = ''
      switch () {
        nh os switch --update ~/pj/nixos-config ;
      }
    '';
  };
}