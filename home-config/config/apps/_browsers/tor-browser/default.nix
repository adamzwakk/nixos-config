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
  cfg = config.${namespace}.apps._browsers.tor;
in
{
    home.packages = with pkgs; [ 
      tor-browser
    ];  
}