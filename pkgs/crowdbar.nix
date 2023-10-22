{ lib, python3, poetry2nix, fetchFromGitHub }:

poetry2nix.mkPoetryApplication {
  projectDir = fetchFromGitHub {
    owner = "seirl";
    repo = "crowdbar";
    rev = "847503d9eb68cd7d8ebf65de305678087682b4f2";
    sha256 = "sha256-GbkveS102BD8+XoFm6VatafwZy60WezkdxD3Oa3C+H4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    gunicorn
  ];

  meta = with lib; {
    homepage = "https://github.com/seirl/crowdbar";
    description = "An embeddable crowdfunding progress bar for OBS streams.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
