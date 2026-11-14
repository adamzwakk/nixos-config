{
  config,
  pkgs,
  lib,
  flake-inputs,
  ...
}:
with lib;
{
  options.lv426.system.audio.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable audio";
  };

  config = mkIf config.lv426.system.audio.enable {
    services = {
      pipewire = {
        enable = true;

        alsa = {
          enable = true;
          support32Bit = true;
        };

        #jack.enable = true; evaluation warning: `services.pipewire.jack.enable` is deprecated, because it introduces global impurity via `LD_LIBRARY_PATH`. Use the `pw-jack` wrapper from `pipewire.jack` where necessary instead.
        pulse.enable = true;
        wireplumber.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      playerctl            # Get music metadata from media players
    ];
  };
}