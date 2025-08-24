{ pkgs, config, lib, ... }:
{
  networking.networkmanager = {
    enable = true;
    wifi = lib.mkIf config.networking.wireless.iwd.enable {
      backend = "iwd";
    };
  };
}