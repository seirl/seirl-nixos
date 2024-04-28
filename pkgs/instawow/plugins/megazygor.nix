{ lib, python3, p7zip, unar, fetchFromBitbucket, fetchPypi, instawow }:

let
  mediafire = python3.pkgs.buildPythonPackage rec {
    pname = "mediafire";
    version = "0.6.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "a1adfeff43dfb611d560c920f6ec18a05b5197b2b15093b08591e45ce879353e";
    };
    propagatedBuildInputs = with python3.pkgs; [
      requests
      requests-toolbelt
      six
    ];
    meta = with lib; {
      description = "Python MediaFire client library";
      homepage = "https://pypi.org/project/mediafire/";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ seirl ];
    };
  };
in

python3.pkgs.buildPythonPackage rec {
  pname = "instawow_megazygor";
  version = "c91cc6c38aad5a9d2b4e6c834e4efac95d86966c";

  src = fetchFromBitbucket {
    owner = "serialk";
    repo = "instawow-megazygor";
    rev = version;
    sha256 = "sha256-mBD5xQdBblg53gZwseuOoYkkIntY4RpaiSRHrS4SnnQ=";
  };

  postPatch = ''
    substituteInPlace instawow_megazygor/archives.py \
      --replace-fail "LSAR_PATH = 'lsar'" "LSAR_PATH = '${unar}/bin/lsar'" \
      --replace-fail "UNAR_PATH = 'unar'" "UNAR_PATH = '${unar}/bin/unar'"
  '';

  pythonRemoveDeps = [
    "instawow" # Reverse the dependency
  ];
  doCheck = false; # tests require dependencies

  nativeBuildInputs = with python3.pkgs; [ setuptools ];
  propagatedBuildInputs = (with python3.pkgs; [
    aiohttp
    mediafire
    requests
    six
  ]);

  meta = with lib; {
    homepage = "https://bitbucket.org/serialk/instawow-megazygor";
    description = "Instawow plugin for MegaZygor";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
