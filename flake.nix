{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
  };
  outputs = { self, nixpkgs, ... } @ inputs: rec {
    # Custom packages
    packages.x86_64-linux = import ./pkgs rec {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };
    };

    # Colmena hive output
    colmena =
      let
        machines = import ./machines;
      in
      {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
          };
        };
        defaults = { pkgs, ... }: {
          imports = [
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.nur.modules.nixos.default
          ];
          nixpkgs.overlays = [
            (final: prev: self.packages.x86_64-linux)
          ];
          home-manager.sharedModules = [
            inputs.sops-nix.homeManagerModules.sops
            {
              config = {
                news.display = "silent";
                news.json = pkgs.lib.mkForce { };
                news.entries = pkgs.lib.mkForce [ ];
              };
            }
          ];

          # deployment.replaceUnknownProfiles = true;
          deployment.allowLocalDeployment = true;

          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
        };
      } // machines;

    nixosConfigurations = (inputs.colmena.lib.makeHive self.colmena).nodes;

    images = builtins.mapAttrs
      (name: value: value.config.system.build.sdImage)
      (nixpkgs.lib.attrsets.filterAttrs (n: v: v ? config.system.build.sdImage)
        nixosConfigurations);

    homeConfigurations = rec {
      seirlcorp = inputs.home-manager.lib.homeManagerConfiguration rec {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          {
            imports = [ ./home inputs.sops-nix.homeManagerModules.sops ];
            config = {
              my.home.graphical.enable = true;
              my.home.laptop.enable = true;
              my.home.glinux.enable = true;
              home.stateVersion = "25.05";

              targets.genericLinux.enable = true;
              nixpkgs.config.allowUnfree = true;
            };
          }
        ];
      };
      "seirl@seirl3" = seirlcorp;
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    devShell.x86_64-linux =
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      in
      pkgs.mkShell {
        packages = with pkgs; [
          pkgs.colmena
          ssh-to-age
          home-manager
          sops
          (writeShellScriptBin "setup-age-private-key" ''
            mkdir -p ~/.config/sops/age
            echo -n "SSH passphrase: "
            read -s SSH_TO_AGE_PASSPHRASE
            export SSH_TO_AGE_PASSPHRASE
            ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
          '')
        ];
      };
  };
}
