{
  config,
  lib,
  pkgs,
  inputs,
  nmEnabled,
  lv426,
  flake-inputs,
  ...
}:
with lib;
{
  config = mkIf lv426.desktop.noctalia.enable {

    programs.noctalia = {
      enable = true;

      settings = { # This may also be a string or path to a .toml file.
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        shell.screenshot = {
          save_to_file = false;
          copy_to_clipboard = true;
        };

        wallpaper = {
          enabled = true;
          directory = "${flake-inputs.self}/_wallpapers/";
        };
      };
    };
  };
}
