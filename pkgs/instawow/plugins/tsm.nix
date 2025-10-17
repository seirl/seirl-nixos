{ lib, python3, fetchFromGitHub, instawow }:

python3.pkgs.buildPythonPackage rec {
  pname = "instawow-tsm";
  version = "f1cdfc6f9163940d39c6e6faf13e5f1c797b45c0";

  src = fetchFromGitHub {
    owner = "seirl";
    repo = "instawow-tsm";
    rev = version;
    sha256 = "sha256-dfzor5+WOM+7+nycABAuoHysK4Fao0J930P+RXovpoE=";
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

  pyproject = true;
  build-system = [ python3.pkgs.setuptools ];

  meta = with lib; {
    homepage = "https://github.com/seirl/instawow-tsm";
    description = "Instawow plugin for TradeSkillMaster";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
