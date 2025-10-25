{
    # nixConfig = {
    #   extra-substituters = [
    #     "https://niri.cachix.org"
    #   ];
    #   extra-trusted-public-keys = [
    #     "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    #   ];
    # };

    inputs = {
        stable.url = "github:nixos/nixpkgs/release-25.05";
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
        # nixvim = {
        #     url = "github:nix-community/nixvim";
        #     inputs.nixpkgs.follows = "nixpkgs";
        # };

        # Helpful rust bundles
        rust-overlay = {
            url = "github:oxalica/rust-overlay";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Secure Boot
        lanzaboote = {
          url = "github:nix-community/lanzaboote/v0.4.2";

          # Optional but recommended to limit the size of your system closure.
          inputs.nixpkgs.follows = "nixpkgs";
        };

        niri = {
          url = "github:sodiboo/niri-flake";
          inputs.nixpkgs.follows = "nixpkgs";
        };

        swww.url = "github:LGFae/swww";

        # flake helpers
        utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    };

    outputs = { self, nixpkgs, sops-nix, rust-overlay, nixos-hardware, ... }@inputs: let
      system = "x86_64-linux";
      overlays = [ 
        (import rust-overlay)
      ];
      pkgs = import nixpkgs { 
        inherit system overlays;  
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        TKF13 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/system
            ./modules/system/hosts/TKF13
          ];

          specialArgs.flake-inputs = inputs;
        };

        ZwakkTower = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/system
            ./modules/system/hosts/ZwakkTower
          ];

          specialArgs.flake-inputs = inputs;
        };
      };

      packages.${system} = pkgs.lib.packagesFromDirectoryRecursive {
        callPackage = pkgs.lib.callPackageWith (pkgs // { inherit (pkgs) lib; });
        directory = ./modules/packages;
      };

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
      
      devShells.x86_64-linux.rust =
        nixpkgs.legacyPackages.x86_64-linux.mkShell {
          packages = with pkgs; [
            (rust-bin.stable.latest.default.override {
              extensions = ["rust-src"];
            })
            rustup 
            gcc
          ];
        };
    };
}
