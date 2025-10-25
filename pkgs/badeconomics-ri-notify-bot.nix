{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "badeconomics-ri-notify-bot";
  version = "0.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reddit-economics";
    repo = "ri-notify-bot";
    rev = "c8d221549775891c71eb1b0cc836b95deba80708";
    sha256 = "sha256-RlDydGXpp8B3qQImtbNdK0VZclCDgDOZMd7+1HSeAyU=";
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
