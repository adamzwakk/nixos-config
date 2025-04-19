## Get Started

Start by doing the initial flake with

`sudo nixos-rebuild switch --flake .#{your hostname here}` (ZwakkTower, TKF13)

then from then on you can just run `switch` to update the system config

## SOPS notes

To add a new key to the existing sops-setup, add or copy a user one and add the new system one to the `.sops.yaml` file and then run `sops --config .sops.yaml updatekeys secrets/secrets.yaml`

## Cheat Sheets

### Nix
```
switch      update system config
```

### spotify_player
```
g           Global Shortcuts
g+b         Browse/Homepage
a           Actions on current track
Ctrl-s      ToggleShuffle
```

## Inspiration/credit

- https://github.com/wueestry/nixos-config
- https://github.com/TLATER/dotfiles/
- https://github.com/xhos/nixdots/
- https://github.com/dc-tec/nixos-config/
- https://github.com/khaneliman/khanelinix
- https://0xda.de/blog/2024/07/framework-and-nixos-sops-nix-secrets-management/