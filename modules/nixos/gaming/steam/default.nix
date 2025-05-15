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
  cfg = config.${namespace}.gaming.steam;
in
{
  options.${namespace}.gaming.steam = with types; {
    enable = mkBoolOpt false "Enable steam";
  };

  config = mkIf cfg.enable {

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
    };

    environment.systemPackages = with pkgs; [
      protontricks
    ];
  };
}