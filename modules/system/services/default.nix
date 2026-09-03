{
  options,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./displaymanager/greetd.nix
    ./displaymanager/sddm.nix

    ./docker.nix
    ./hyprlock.nix

    ./usenet.nix
    ./transmission.nix
  ];

  options.lv426.hoarding.downloadBaseDir = lib.mkOption {
    type = lib.types.str;
    default = "/home/adam/Downloads";
    description = "Download hoarding base directory";
  };
}