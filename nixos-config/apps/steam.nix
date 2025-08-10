{ pkgs, ... }:
{
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

  # nixpkgs.config.allowUnfreePredicate =
  #   pkg:
  #   builtins.elem (pkgs.lib.getName pkg) [
  #     "steam"
  #     "steam-run"
  #     # Required to get the steam controller to work (i.e., for hardware.steam-hardware)
  #     "steam-original"
  #     "steam-unwrapped"
  #   ];
}