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
  };
  outputs = { self, nixpkgs, ... } @ inputs: {
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
    devShell.x86_64-linux =
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      in
      pkgs.mkShell {
        buildInputs = with pkgs; [
          colmena
          ssh-to-age
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
