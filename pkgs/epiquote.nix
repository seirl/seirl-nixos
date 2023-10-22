{ lib, python3, poetry2nix, fetchFromGitHub }:

poetry2nix.mkPoetryApplication {
  projectDir = fetchFromGitHub {
    owner = "seirl";
    repo = "epiquote";
    rev = "98d0dac197f157192c758339d73d9e93bf005922";
    sha256 = "sha256-3qDaUiysiZ/7+te/UxHfwUppWq0o7vpA4wtyTfww7Mo=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    gunicorn
  ];

  postInstall = ''
    export DJANGO_SETTINGS_MODULE="epiquote.settings"
    mkdir -p $out/static
    cat <<EOF > settings.ini
    [epiquote]
      static_root = $out/static
    EOF
    export EPIQUOTE_SETTINGS_PATH=./settings.ini
    python3 ./manage.py collectstatic --noinput
  '';

  meta = with lib; {
    homepage = "https://github.com/seirl/epiquote";
    description = "A quote repository website";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
