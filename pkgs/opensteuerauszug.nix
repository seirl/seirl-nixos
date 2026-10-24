{ pkgs
, lib
, fetchFromGitHub
, uv2nix
, pyproject-nix
, pyproject-build-systems
, ...
}:

let
  version = "0-unstable-2026-10-21";
  src = fetchFromGitHub {
    owner = "vroonhof";
    repo = "opensteuerauszug";
    rev = "c707ab75f1dcbb0ba0c280d09635d80fe00d8d98";
    sha256 = "sha256-B6e+NtRz5ThXNpujjtXfPz0Qqa/Utd648y6+/vyK4jg=";
  };

  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = src; };
  overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };

  pyprojectOverrides = final: prev: {
    ibflex2 = prev.ibflex2.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        final.setuptools
      ];
    });
    pdf417gen = prev.pdf417gen.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        final.setuptools
        final.setuptools-scm
        final.vcs-versioning
      ];
      SETUPTOOLS_SCM_PRETEND_VERSION = old.version;
    });
    pdf417decoder = prev.pdf417decoder.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        final.setuptools
      ];
    });
    opensteuerauszug = prev.opensteuerauszug.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        final.hatchling
      ];
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

  env = pythonSet.mkVirtualEnv "opensteuerauszug" workspace.deps.default;

  testEnv = pythonSet.mkVirtualEnv "opensteuerauszug-test-env" {
    opensteuerauszug = [ "dev" ];
  };

in
env.overrideAttrs (old: {
  inherit version src;

  passthru = (old.passthru or { }) // {
    inherit pythonSet testEnv;
    tests = {
      pytest = pkgs.runCommand "opensteuerauszug-pytest" {
        nativeBuildInputs = [ testEnv ];
      } ''
        cp -r ${src}/. .
        chmod -R +w .
        pytest
        touch $out
      '';
    };
  };

  meta = with lib; {
    homepage = "https://github.com/vroonhof/opensteuerauszug";
    description = "Tool to generate swiss e-steuerauszug from banking exports";
    license = licenses.mit;
    maintainers = with maintainers; [ seirl ];
    mainProgram = "opensteuerauszug";
  };
})
