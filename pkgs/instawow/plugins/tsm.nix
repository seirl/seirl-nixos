{ lib, python3, fetchFromGitHub, instawow }:

python3.pkgs.buildPythonPackage rec {
  pname = "instawow-tsm";
  version = "83a315850dad9cbbb62fad75407b34fb30d0efa1";

  src = fetchFromGitHub {
    owner = "seirl";
    repo = "instawow-tsm";
    rev = version;
    sha256 = "sha256-aF+/Z7cvnECYayRvshzLpAQDyiaEtqlImaKulccsT9A=";
  };

  pythonRemoveDeps = [
    "instawow" # Reverse the dependency
  ];
  doCheck = false; # tests require dependencies

  nativeBuildInputs = with python3.pkgs; [ setuptools ];
  propagatedBuildInputs = (with python3.pkgs; [
    aiohttp
    click
    loguru
  ]);

  meta = with lib; {
    homepage = "https://github.com/seirl/instawow-tsm";
    description = "Instawow plugin for TradeSkillMaster";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
