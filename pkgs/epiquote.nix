{ pkgs
, lib
, fetchFromGitHub
, uv2nix
, pyproject-nix
, pyproject-build-systems
, ...
}:

let
  version = "0-unstable-2026-07-13";
  src = fetchFromGitHub {
    owner = "seirl";
    repo = "epiquote";
    rev = "1ac54dc325059677a43d5b838dfaafe4e3597815";
    sha256 = "sha256-7E2F9TKNfMlp9zeW92wyt2e0RCie51UmYwlSNaVjSns=";
  };

  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = src; };
  overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };

  pyprojectOverrides = final: prev: {
    psycopg2-binary = prev.psycopg2-binary.overrideAttrs (old: {
      nativeBuildInputs =
        (old.nativeBuildInputs or [ ]) ++ [ pkgs.postgresql.pg_config ];
    });
    django-bootstrap-form = prev.django-bootstrap-form.overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ final.setuptools ];
    });
  };

  pythonSet = (pkgs.callPackage pyproject-nix.build.packages {
    python = pkgs.python3;
  }).overrideScope (
    lib.composeManyExtensions [
      pyproject-build-systems.overlays.default
      overlay
      pyprojectOverrides
    ]
  );

  epiquote-env = pythonSet.mkVirtualEnv "epiquote-env" {
    epiquote = [ "prod" ];
  };

  epiquote-statics = pkgs.stdenv.mkDerivation {
    pname = "epiquote-statics";
    inherit version src;

    nativeBuildInputs = [ epiquote-env ];

    buildPhase = ''
      # Output statics directly into $out
      mkdir -p $out/static

      cat <<EOF > build_settings.ini
      [epiquote]
      static_root = $out/static
      EOF
      export EPIQUOTE_SETTINGS_PATH=$(pwd)/build_settings.ini

      python manage.py collectstatic --noinput
    '';

    installPhase = "true";
  };

  epiquote-tests = pkgs.stdenv.mkDerivation {
    pname = "epiquote-tests";
    inherit version src;
    nativeBuildInputs = [ epiquote-env ];
    dontBuild = true;
    doCheck = true;
    checkPhase = ''
      python manage.py test -v 1
    '';
    installPhase = "mkdir -p $out";
  };

in
pkgs.symlinkJoin {
  name = "epiquote";
  pname = "epiquote";
  inherit version src;

  paths = [
    epiquote-env
    epiquote-statics
    epiquote-tests
  ];

  passthru = {
    inherit epiquote-env epiquote-statics epiquote-tests;
  };

  meta = with lib; {
    homepage = "https://github.com/seirl/epiquote";
    description = "A quote repository website";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
