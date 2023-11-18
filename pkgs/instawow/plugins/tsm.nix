{ lib, python3, fetchFromGitHub, instawow }:

python3.pkgs.buildPythonPackage rec {
  pname = "instawow-tsm";
  version = "4443f25ba7542b011914e278d2c89663a90d73e7";

  src = fetchFromGitHub {
    owner = "seirl";
    repo = "instawow-tsm";
    rev = version;
    sha256 = "sha256-+TOGPXyUGxmgpm/ncUGx6uZwAlafQUkJMa85RoJB99c=";
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
