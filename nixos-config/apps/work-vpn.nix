{ pkgs, ... }:
{
  # TODO: maybe implement https://github.com/jmackie/nixos-networkmanager-profiles and write the conncetion from /etc/NetworkManager/system-connections/ here
  
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
  ];
}