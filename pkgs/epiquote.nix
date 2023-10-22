{ lib, python3, poetry2nix, fetchFromGitHub }:

poetry2nix.mkPoetryApplication {
  projectDir = fetchFromGitHub {
    owner = "seirl";
    repo = "epiquote";
    rev = "e52233b08c2b6d68872ac13e4dc28796beb4a453";
    sha256 = "sha256-/qkKjzdnwY9B7zGN6DYcCF+TU3RNmyN5ksmblR/b5Do=";
  };

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
