let
  base = {
    meta = {
      nixpkgs = <nixpkgs>;
    };

    defaults = { pkgs, ... }: {
      imports = [
        ./common
      ];
      # deployment.replaceUnknownProfiles = true;
      deployment.allowLocalDeployment = true;
    };
  };

  machines = import ./machines;

in
  base // machines
