{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
        unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        snowfall-lib = {
            url = "github:snowfallorg/lib";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-hardware.url = "github:nixos/nixos-hardware";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        plasma-manager = {
            url = "github:nix-community/plasma-manager";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };

        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs:
        inputs.snowfall-lib.mkFlake {
            inherit inputs;
            src = ./.;

            snowfall = {
                namespace = "lv426";
                meta = {
                    name = "lv426";
                    title = "LV426";
                };
            };

            channels-config = {
              allowUnfree = true;
            };

            overlays = with inputs; [
                nur.overlays.default
            ];

            homes.modules = with inputs; [
                plasma-manager.homeManagerModules.plasma-manager
            ];

            systems.hosts.TKF13.modules = with inputs; [ 
                nixos-hardware.nixosModules.framework-13-7040-amd 
            ];

            systems.hosts.ZwakkTower.modules = with inputs; [ 
                nixos-hardware.nixosModules.common-cpu-amd
                nixos-hardware.nixosModules.common-gpu-amd
            ];

        };
}