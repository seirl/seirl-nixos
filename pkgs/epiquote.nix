{ lib, python3, poetry2nix, fetchFromGitHub }:

poetry2nix.mkPoetryApplication {
  projectDir = fetchFromGitHub {
    owner = "seirl";
    repo = "epiquote";
    rev = "d13e0972a068b0e15daed15da80de56ac3c306e4";
    sha256 = "sha256-NSHcEvCEnDz/0xqLJ3L6VEHvqBLzcsiIiksrLY5YZ44=";
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
      confusable-homoglyphs = [ "setuptools" ];
      django-bootstrap-form = [ "setuptools" ];
      django-registration = [ "setuptools" ];
      sqlparse = [ "flit-core" ];
      urllib3 = [ "hatchling" ];
    }
  );

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    gunicorn
  ];

  postInstall = ''
    export DJANGO_SETTINGS_MODULE="epiquote.settings"
    mkdir -p $out/static
    cat <<EOF > settings.ini
    [epiquote]
      static_root = $out/static
    EOF
    export EPIQUOTE_SETTINGS_PATH=./settings.ini
    python3 ./manage.py collectstatic --noinput
  '';

  meta = with lib; {
    homepage = "https://github.com/seirl/epiquote";
    description = "A quote repository website";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
