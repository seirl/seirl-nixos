{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
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
            home-manager.nixosModules.home-manager
          ];

          # deployment.replaceUnknownProfiles = true;
          deployment.allowLocalDeployment = true;

          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;

          system.stateVersion = "22.11";
        };
      } // machines;

    # Home configurations.
    # This exposes the home configurations of each user@host pair directly by
    # extracting them from the generated colmena hive config. This allows
    # non-NixOS nodes to apply their home-manager config locally.
    homeConfigurations =
      let
        hive = (inputs.colmena.lib.makeHive self.colmena);
      in
      with nixpkgs.lib; listToAttrs (
        flatten (
          mapAttrsToList
            (machine: machineConfig: (
              mapAttrsToList
                (user: homeConfig: (
                  { name = "${user}@${machine}"; value = homeConfig; }
                ))
                machineConfig.config.home-manager.users
            ))
            hive.nodes
        )
      );

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}
