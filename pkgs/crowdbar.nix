{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonPackage rec {
  pname = "crowdbar";
  version = "141346e12efa48fa0153ccdce43525d79cec0b53";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seirl";
    repo = "crowdbar";
    rev = "${version}";
    sha256 = "sha256-8WARWPX6biag2Q9flsbeJn/O49C3f4UOL40lDy7JUNs=";
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
