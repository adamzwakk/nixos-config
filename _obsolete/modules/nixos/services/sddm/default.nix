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
    cfg = config.${namespace}.services.sddm;
    vanilla_theme = builtins.fromTOML(builtins.readFile "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme/Themes/black_hole.conf");
    theme = vanilla_theme.General;

    sddm-astronaut = pkgs.sddm-astronaut.override {
      themeConfig = theme;
    };
  in
  {
    options.${namespace}.services.sddm = with types; {
      enable = mkBoolOpt false "Enable SDDM";
    };

    config = mkIf cfg.enable {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        enableHidpi = true;
        package = lib.mkForce pkgs.kdePackages.sddm; # qt6 sddm version
        extraPackages = [pkgs.sddm-astronaut];
        theme = "sddm-astronaut-theme";
      };

      security.pam.services.sddm.enableGnomeKeyring = true;

      environment.systemPackages = with pkgs; [
        sddm-astronaut
        kdePackages.qtmultimedia
      ];
    };
}