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
  cfg = config.${namespace}.security.sops;
in
{
  options.${namespace}.security.sops = with types; {
    enable = mkBoolOpt false "Enable sops";
  };

  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = lib.snowfall.fs.get-file "secrets/secrets.yaml";
      
      age = {
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
      
      secrets = {
        syncthing-hudson-id = {};
      };
    };
  };
}