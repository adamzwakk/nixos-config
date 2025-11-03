{
  pkgs,
  lib,
  flake-inputs,
  ...
}:
{
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.epkowa ];
  services.udev.packages = [ flake-inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.vuescan.default ];
  environment.systemPackages = [ 
    flake-inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.vuescan.default
    flake-inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.epson-v600-plugin.default
  ];
  system.activationScripts.iscanPluginLibraries = ''
    mkdir -p /usr/share/iscan
    mkdir -p /usr/lib/iscan
    ln -sf ${flake-inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.epson-v600-plugin.default}/share/iscan/* /usr/share/iscan
    ln -sf ${flake-inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.epson-v600-plugin.default}/lib/iscan/* /usr/lib/iscan
  '';
}