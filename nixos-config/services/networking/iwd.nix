{ pkgs, ... }:
{
  networking.wireless.iwd = {
    enable = true;
    settings = {
      IPv6 = {
        Enabled = true;
      };
      Settings = {
        AutoConnect = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    impala
  ];
}