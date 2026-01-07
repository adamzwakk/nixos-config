{ pkgs, config, lib, ... }:
let
  vmDir = "${config.home.homeDirectory}/.local/share/86Box/Virtual Machines";
  ## Put INI style configs here maybe?
in
{
  # You need this if you’re enabling unfree ROMs
 
  home = {
    packages = [
      (pkgs._86Box.override {
        unfreeEnableRoms = true;
      })
      pkgs.gamemode
    ];

    file = {
      "${vmDir}/Pentium1/86box.cfg".source = ./cfgs/Pentium1.cfg;
    };
    

    ## It doesnt know gamemodelib exists without this, bad hack but oh well
    shellAliases."86Box" = "LD_PRELOAD=\"$LD_PRELOAD:${pkgs.gamemode.lib}/lib/libgamemode.so\" 86Box";
  };

  wayland.windowManager.hyprland.settings.windowrule = lib.mkAfter [
    "float on,match:class ^(net.86box.86Box)$"
  ];
}