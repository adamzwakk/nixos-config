{
  options,
  config,
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.sops;
in
{
  # imports = [ inputs.sops-nix.nixosModules.sops ];

  # options.${namespace}.tools.sops = with types; {
  #   enable = mkBoolOpt false "Enable sops";
  # };

  # config = mkIf cfg.enable {
  #   environment.systemPackages = with pkgs; [
  #     age
  #     sops
  #     ssh-to-age
  #   ];

  #   sops = {
  #     defaultSopsFile = lib.snowfall.fs.get-file "secrets/secrets.yaml";
  #     defaultSopsFormat = "yaml";
      
  #     age.keyFile = "/home/${config.lv426.config.user.name}/.config/sops/age/keys.txt";
  #     age.generateKey = true;

  #     secrets.hudson_syncthing_id = {};
  #   };
  # };
}