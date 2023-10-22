{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "badeconomics-ri-notify-bot";
  version = "c8d221549775891c71eb1b0cc836b95deba80708";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "reddit-economics";
    repo = "ri-notify-bot";
    rev = version;
    sha256 = "sha256-RlDydGXpp8B3qQImtbNdK0VZclCDgDOZMd7+1HSeAyU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-scm
    praw
    # python3.pkgs.databases is marked as broken, only needed for check
    (slack-sdk.overridePythonAttrs (_: { doCheck = false; }))
  ];

  meta = with lib; {
    homepage = "https://github.com/reddit-economics/ri-notify-bot";
    description = "Notifies new RIs posted on /r/badeconomics";
    license = licenses.bsd3;
    maintainers = with maintainers; [ seirl ];
  };
}
