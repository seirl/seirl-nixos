{ lib, python3, fetchFromGitHub, instawow }:

python3.pkgs.buildPythonPackage rec {
  pname = "instawow-tsm";
  version = "0-unstable-2025-10-17";

  src = fetchFromGitHub {
    owner = "seirl";
    repo = "instawow-tsm";
    rev = "be164bb322e5e283dee6bdfa268a0a749217126a";
    sha256 = "sha256-EOXcy0ovvZPm5nO9v9r/lV/Kx19LNmNmLAVnOb/0Bp4=";
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
