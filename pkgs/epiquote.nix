{ lib, python3, poetry2nix, fetchFromGitHub }:

poetry2nix.mkPoetryApplication {
  # projectDir = fetchFromGitHub {
  #   owner = "seirl";
  #   repo = "epiquote";
  #   rev = "d087372187675be1c0503e122ddc9d3c8f2e3864";
  #   sha256 = "sha256-4WweDj8lbJk+LiWG0qylMBkRGxhcuQgiTTz5Wf13bSQ=";
  # };
  projectDir = /home/seirl/code/epiquote;

  # workaround https://github.com/nix-community/poetry2nix/issues/568
  overrides = poetry2nix.overrides.withDefaults (self: super:
    let
      addBuildInputs = name: buildInputs: super.${name}.overridePythonAttrs (old: {
        buildInputs = (builtins.map (x: super.${x}) buildInputs) ++ (old.buildInputs or [ ]);
      });
      mkOverrides = lib.attrsets.mapAttrs (name: value: addBuildInputs name value);
    in
    mkOverrides {
      confusable-homoglyphs = [ "setuptools" ];
      sqlparse = [ "flit-core" ];
      urllib3 = [ "hatchling" ];
    }
  );



  propagatedBuildInputs = with python3.pkgs; [
    setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/seirl/epiquote";
    description = "A quote repository website";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
