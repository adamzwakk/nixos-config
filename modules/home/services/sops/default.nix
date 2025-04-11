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
    cfg = config.${namespace}.services.sops;
  in
  {
    options.${namespace}.services.sops = with types; {
    enable = lib.mkEnableOption "sops";
    defaultSopsFile = mkOpt path null "Default sops file.";
    sshKeyPaths = mkOpt (listOf path) [ ] "SSH Key paths to use.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      age
      sops
      ssh-to-age
    ];

    sops = {
      defaultSopsFile = lib.snowfall.fs.get-file "secrets/secrets.yaml";
      defaultSopsFormat = "yaml";

      age = {
        generateKey = true;
        keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      };

      secrets = {
        "private_keys/adam" = {
          path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        };
      };
    };
  };
}