{
  flake-inputs,
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
}