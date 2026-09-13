{
  flake-inputs,
  pkgs,
  ...
}:

{
  imports = [
    ../../services/wlsunset.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard    # Clipboard
    imv             # Image Viewer
  ];

  programs.imv = {
    enable = true;
    settings = { ## https://manpages.ubuntu.com/manpages/lunar/man5/imv-x11.5.html
      options.overlay = true;
    };
  };
}