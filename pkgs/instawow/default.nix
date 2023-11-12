{ lib, python3, fetchFromGitHub, fetchPypi, plugins ? [ ] }:

let
  aiohttp-client-cache = python3.pkgs.buildPythonPackage rec {
    pname = "aiohttp_client_cache";
    version = "0.10.0";
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-FXU4QNqa8B8ZADmoEyJfd8gsUDI0HEjIR9B2CBP55wU=";
    };
    nativeBuildInputs = with python3.pkgs; [
      poetry-core
    ];
    propagatedBuildInputs = with python3.pkgs; [
      aiohttp
      attrs
      itsdangerous
      url-normalize
    ];
    meta = with lib; {
      description = "An async persistent cache for aiohttp requests";
      homepage = "https://pypi.org/project/mediafire/";
      license = licenses.mit;
      maintainers = with maintainers; [ seirl ];
    };
  };
in

python3.pkgs.buildPythonApplication rec {
  pname = "instawow";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "layday";
    repo = pname;
    rev = version;
    sha256 = "sha256-li5rtaN6ymjlt5wa2yEbcmqfvUqKzZPKeDxHRm3Ow4U=";
  };

  extras = [ ];
  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];
  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    aiohttp-client-cache
    alembic
    attrs
    cattrs
    click
    iso8601
    loguru
    mako
    packaging
    pluggy
    prompt-toolkit
    questionary
    rapidfuzz
    sqlalchemy
    truststore
    typing-extensions
    yarl
  ] ++ plugins;

  meta = with lib; {
    homepage = "https://github.com/layday/instawow";
    description = "World of Warcraft add-on manager CLI and GUI";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
