{
  config,
  pkgs,
  lib,
  flake-inputs,
  ...
}:
with lib;
{
  options.lv426.system.secure_boot.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable secure boot tools";
  };

  imports = [
    flake-inputs.lanzaboote.nixosModules.lanzaboote
  ];

  config = mkIf config.lv426.system.secure_boot.enable {
    environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}