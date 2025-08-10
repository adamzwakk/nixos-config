{
  pkgs,
  lib,
  flake-inputs,
  ...
}:
{
  imports = [
    flake-inputs.nixos-hardware.nixosModules.framework-13-7040-amd 

    ./hardware-configuration.nix
    ../../apps/steam.nix
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "steam"
      "steam-run"
      # Required to get the steam controller to work (i.e., for hardware.steam-hardware)
      "steam-original"
      "steam-unwrapped"
    ];

  home-manager.users.adam = import "${flake-inputs.self}/home-config/hosts/TKF13.nix";

  # For random android-related things
  programs.adb.enable = true;
  users.users.adam.extraGroups = [ "adbusers" ];
}