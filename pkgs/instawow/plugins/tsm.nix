{ lib, python3, fetchFromGitHub, instawow }:

python3.pkgs.buildPythonPackage rec {
  pname = "instawow-tsm";
  version = "6db1c8d6ce824620563d1e1091a26c9d1f5addc7";

  src = fetchFromGitHub {
    owner = "seirl";
    repo = "instawow-tsm";
    rev = version;
    sha256 = "sha256-fkkHZlg1o+NiSl9PA8yvej3xhhDO0P9z6YJUuWsdWFY=";
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
