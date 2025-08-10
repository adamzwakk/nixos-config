{
    inputs = {
        stable.url = "github:nixos/nixpkgs/release-24.11";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        nixos-hardware.url = "github:nixos/nixos-hardware";

        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        plasma-manager = {
            url = "github:nix-community/plasma-manager";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };

        # Mostly used for FF extensions
        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Secret keeping
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Styling rules at a global level
        stylix = {
            url = "github:danth/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # An easier way to config nvim
        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Helpful rust bundles
        rust-overlay = {
            url = "github:oxalica/rust-overlay";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # flake helpers
        utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    };

    outputs =
    { nixpkgs, sops-nix, nixos-hardware, ... }@inputs:
    {
      nixosConfigurations = {
        TKF13 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-config
            ./nixos-config/hosts/TKF13
          ];

          specialArgs.flake-inputs = inputs;
        };
      };

      # packages.x86_64-linux = import ./pkgs {
      #   pkgs = nixpkgs.legacyPackages.x86_64-linux;
      #   flake-inputs = inputs;
      # };

      # TODO: Put this shell somewhere else?
      devShells.x86_64-linux.default =
        let
          inherit (sops-nix.packages.x86_64-linux) sops-init-gpg-key sops-import-keys-hook ;
          inherit (nixpkgs.legacyPackages.x86_64-linux) nushell nvfetcher age sops ssh-to-age;
        in
        nixpkgs.legacyPackages.x86_64-linux.mkShell {
          packages = [
            nushell
            nvfetcher
            sops-init-gpg-key
            age
            sops
            ssh-to-age
          ];

          nativeBuildInputs = [ sops-import-keys-hook ];
        };

    # outputs = inputs:
    #     inputs.snowfall-lib.mkFlake {
    #         inherit inputs;
    #         src = ./.;

    #         snowfall = {
    #             namespace = "lv426";
    #             meta = {
    #                 name = "lv426";
    #                 title = "LV426";
    #             };
    #         };

    #         channels-config = {
    #           allowUnfree = true;
    #         };

    #         overlays = with inputs; [
    #             nur.overlays.default
    #             rust-overlay.overlays.default
    #         ];

    #         homes.modules = with inputs; [
    #             plasma-manager.homeManagerModules.plasma-manager
    #             sops-nix.homeManagerModules.sops
    #             nixvim.homeModules.nixvim
    #             stylix.homeModules.stylix
    #         ];

    #         systems.hosts.TKF13.modules = with inputs; [ 
    #             nixos-hardware.nixosModules.framework-13-7040-amd 
    #         ];

    #         systems.hosts.ZwakkTower.modules = with inputs; [ 
    #             nixos-hardware.nixosModules.common-cpu-amd
    #             nixos-hardware.nixosModules.common-gpu-amd
    #         ];

        };
}
