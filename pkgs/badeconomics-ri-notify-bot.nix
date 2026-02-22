{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "badeconomics-ri-notify-bot";
  version = "0.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reddit-economics";
    repo = "ri-notify-bot";
    rev = "5c7f51b475a95b2d4a12092185df3d009d8f4ca7";
    sha256 = "sha256-7SAaS/oXfTqSe81bqA9bC8cVwTiw2wVTR633UDcutDw=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-scm
    praw
    slack-sdk
  ];

  meta = with lib; {
    homepage = "https://github.com/reddit-economics/ri-notify-bot";
    description = "Notifies new RIs posted on /r/badeconomics";
    license = licenses.bsd3;
    maintainers = with maintainers; [ seirl ];
  };
}
