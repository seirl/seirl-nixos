{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }:
    let
      machines = import ./machines;
    in
    {
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
          };
        };
        defaults = { pkgs, ... }: {
          imports = [
            home-manager.nixosModules.home-manager
            ./common
          ];
          # deployment.replaceUnknownProfiles = true;
          deployment.allowLocalDeployment = true;

          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;

          system.stateVersion = "22.11";
        };
      } // machines;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
