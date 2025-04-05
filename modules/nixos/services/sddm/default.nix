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
    theme = builtins.fromTOML(builtins.readFile "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme/Themes/pixel_sakura.conf");
    sddm-astronaut = pkgs.sddm-astronaut.override {
      themeConfig = theme.General;
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
        package = pkgs.kdePackages.sddm; # qt6 sddm version
        extraPackages = [pkgs.sddm-astronaut];
        theme = "sddm-astronaut-theme";
      };

      security.pam.services.sddm.enableKwallet = true; ## For keyring hopefully? if no kde maybe I should use GNOME one tho

      environment.systemPackages = with pkgs; [
        sddm-astronaut
        kdePackages.qtmultimedia
      ];
    };
}