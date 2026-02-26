{ pkgs
, lib
, fetchFromGitHub
, uv2nix
, pyproject-nix
, pyproject-build-systems
, ...
}:

let
  version = "0-unstable-2026-02-26";
  src = fetchFromGitHub {
    owner = "seirl";
    repo = "epiquote";
    rev = "908bc9c1b56f089deccca87c2924db4c04fefcbd";
    sha256 = "sha256-49epRkI6jEZ9HJ/kbn7XShgcVPLbivDuA0DqEU3W5Io=";
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

in
pkgs.symlinkJoin {
  name = "epiquote";
  pname = "epiquote";
  inherit version src;

  paths = [
    epiquote-env
    epiquote-statics
  ];

  passthru = {
    inherit epiquote-env epiquote-statics;
  };

  meta = with lib; {
    homepage = "https://github.com/seirl/epiquote";
    description = "A quote repository website";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
