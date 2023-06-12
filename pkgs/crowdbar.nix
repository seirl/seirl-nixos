{ lib, python3, poetry2nix, fetchFromGitHub }:

poetry2nix.mkPoetryApplication {
  projectDir = fetchFromGitHub {
    owner = "seirl";
    repo = "crowdbar";
    rev = "847503d9eb68cd7d8ebf65de305678087682b4f2";
    sha256 = "sha256-GbkveS102BD8+XoFm6VatafwZy60WezkdxD3Oa3C+H4=";
  };

  # https://github.com/nix-community/poetry2nix/blob/master/docs/edgecases.md#modulenotfounderror-no-module-named-packagename
  overrides = poetry2nix.overrides.withDefaults (self: super:
    let
      addBuildInputs = name: buildInputs: super.${name}.overridePythonAttrs (old: {
        buildInputs = (builtins.map (x: super.${x}) buildInputs) ++ (old.buildInputs or [ ]);
      });
      mkOverrides = lib.attrsets.mapAttrs (name: value: addBuildInputs name value);
    in
    mkOverrides {
      attrs = [ "hatch-fancy-pypi-readme" "hatch-vcs" ];
    }
  );

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    gunicorn
  ];

  meta = with lib; {
    homepage = "https://github.com/seirl/crowdbar";
    description = "An embeddable crowdfunding progress bar for OBS streams.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
