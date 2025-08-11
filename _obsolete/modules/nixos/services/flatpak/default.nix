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
    cfg = config.${namespace}.services.flatpak;
  in
  {
    options.${namespace}.services.flatpak = with types; {
      enable = mkBoolOpt false "Enable Flatpak";
    };

    config = mkIf cfg.enable {
      services.flatpak = {
        enable = true;
      };

      systemd.services.flatpak-repo = {
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.flatpak ];
        script = ''
          flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        '';
      };
    };
}