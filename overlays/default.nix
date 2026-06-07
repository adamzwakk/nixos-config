{ inputs, ... }:

{
  modifications = final: prev: {

    ## Because of https://github.com/NixOS/nixpkgs/issues/526914#event-26426172692
    bitwarden-desktop = prev.bitwarden-desktop.override {
      electron_39 = final.electron_39-bin;
    };
  };
}