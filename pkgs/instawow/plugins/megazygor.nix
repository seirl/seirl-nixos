{ lib, python3, p7zip, fetchFromBitbucket, fetchPypi, instawow }:

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
  version = "a9239d4c4f30cae0887db0f8cf34d40152733c96";

  src = fetchFromBitbucket {
    owner = "serialk";
    repo = "instawow-megazygor";
    rev = version;
    sha256 = "sha256-HDKIWD28oeD6DPkFPv7PyH96z5gL/CPJY2YP6TJuMO8=";
  };

  pythonRemoveDeps = [
    "instawow" # Reverse the dependency
  ];
  doCheck = false; # tests require dependencies

  nativeBuildInputs = with python3.pkgs; [ setuptools ];
  propagatedBuildInputs = (with python3.pkgs; [
    aiohttp
    mediafire
    patool
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
