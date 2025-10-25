{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "crowdbar";
  version = "f2c481e1381346c4611d9e36b1dd1d404a21ffca";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seirl";
    repo = "crowdbar";
    rev = "${version}";
    sha256 = "sha256-otwvN5QYsSQDat2dDxIzYwLToq6+T8DMKrEn8fJtqU4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    babel
    gunicorn
    jinja2
    lxml
    setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/seirl/crowdbar";
    description = "An embeddable crowdfunding progress bar for OBS streams.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
