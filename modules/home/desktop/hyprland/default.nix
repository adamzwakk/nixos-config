{
  options,
  config,
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.hyprland;
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &

    sleep 1

    ${pkgs.swww}/bin/swww img ${../_wallpapers/wallhaven-0p69qe.png} &
  '';
in
{
  options.${namespace}.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        exec-once = ''${startupScript}/bin/start'';

        "$mod" = "SUPER";
        "$terminal" = "alacritty";
        "$menu" = "rofi --show drun";

        bind = [
	  # main hotkeys
	  "$mod SHIFT, E, exit,"

          # app hotkeys
          "$mod, Return, exec, $terminal"
          "$mod, S, exec, $menu"

	  # Workspace
	  "$mod, 1, workspace, 1"
	  "$mod, 1, workspace, 2"
	  "$mod, 1, workspace, 3"
	  "$mod, 1, workspace, 4"
        ];

	bindm = [
	   # mouse movements
         "$mod, mouse:272, movewindow"
         "$mod, mouse:273, resizewindow"
         "$mod ALT, mouse:272, resizewindow"
	];
	
      };
    };
  };
}
