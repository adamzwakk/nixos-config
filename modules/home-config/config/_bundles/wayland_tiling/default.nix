{
  flake-inputs,
  pkgs,
  ...
}:

{
  imports = [
    ../../apps/rofi.nix

    ../../services/hypridle.nix
    ../../services/mako.nix
    ../../services/wpaperd.nix
    ../../services/wlsunset.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard    # Clipboard
    imv             # Image Viewer
  ];
}