## Get Started

Start by doing the initial flake with

`sudo nixos-rebuild switch --flake .#{your hostname here}` (ZwakkTower, TKF13)

then from then on you can just run `nr` to update the system config

## Structure

Sort of stole ideas from TLATER's config (sorry not sorry):
```
├── home-config
│   ├── config                 --- Home specific Configs
│   └── hosts                  --- Host Specific Config
├── nixos-config
│   ├── apps                   --- Applications that need system level (Steam mostly)
│   ├── default.nix
│   ├── desktop                --- Configs for WM/DE/Greeters/etc
│   └── hosts                  --- Host Specific/Hardware Config
├── packages
│   ├── epson-v600-plugin      --- Plugin/drivers for V600 Scanner
│   ├── sm64coopdx             --- Co-Op SM64
│   ├── sm64ex                 --- SM64 PC Port
│   └── vuescan                --- Vuescan
```

## Networking notes

You can include just `iwd` or `networkmanager` and `iwd` together. I'm okay with running `impala` for hosts that ONLY have wireless and don't need a full blown connection manager (I'm sure I'll regret this but the minimalism just feels good okay?)

## SOPS notes

To add a new key to the existing sops-setup, add or copy a user one and add the new system one to the `.sops.yaml` file and then run `sops --config .sops.yaml updatekeys secrets/secrets.yaml`

## Available Dev Shells

Access different shells by adding a `.envrc` file to a project and specifying the shell you want, for example: `use flake ~/pj/nixos-config/flake.nix#rust` and then `direnv allow` for the directory to use it.

```
Rust    #rust
```

## Cheat Sheets

### Nix
```
nr      update system config
```

### spotify_player
```
a           Actions on current track
g           Global Shortcuts
g+b         Browse/Homepage
n           Next Track
p           Previous Track
Ctrl-s      ToggleShuffle
```

## Inspiration/credit

- https://wearewaylandnow.com/

- https://github.com/wueestry/nixos-config
- https://github.com/TLATER/dotfiles/
- https://github.com/xhos/nixdots/
- https://github.com/dc-tec/nixos-config/
- https://github.com/khaneliman/khanelinix
- https://0xda.de/blog/2024/07/framework-and-nixos-sops-nix-secrets-management/

https://www.reddit.com/r/NixOS/comments/1igd1ep/suggestions_for_opinionated_configs/

## Dockers I should try and replicate somehow but they work anyway more or less

- https://github.com/YanWenKun/ComfyUI-Docker/tree/main/rocm