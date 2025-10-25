{ lib, postgresql, python311, poetry2nix, fetchFromGitHub }:

poetry2nix.mkPoetryApplication {
  projectDir = fetchFromGitHub {
    owner = "seirl";
    repo = "epiquote";
    rev = "69c180346429b861b190f53d56503da0503d1c6a";
    sha256 = "sha256-Zph7HA/qF+y60lM6X0FQp2m+Fb5KIIZXQQ7GmuQaVuU=";
  };

  python = python311;

  overrides = poetry2nix.defaultPoetryOverrides.extend (self: super: {
    psycopg-c = super.psycopg-c.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        postgresql.pg_config
      ];
    });
    psycopg2-binary = super.psycopg2-binary.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        postgresql.pg_config
      ];
    });
    matplotlib = super.matplotlib.overridePythonAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ super.flit-core ];
    });
    matplotlib-inline = super.matplotlib-inline.overridePythonAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ super.flit-core ];
    });
    ipython-pygments-lexers = super.ipython-pygments-lexers.overridePythonAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ super.flit-core ];
    });
  });

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
