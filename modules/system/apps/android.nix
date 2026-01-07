{ pkgs, options, lib, config, ... }:
with lib;
{
  options.lv426.android.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable android tools";
  };

  config = mkIf config.lv426.android.enable {

    # For random android-related things
    environment = {
      systemPackages = with pkgs; [
        android-tools
      ];
    };

    services.udev.packages = [
      pkgs.android-udev-rules
    ];
  };
}