{ lib, python3, fetchFromGitHub, fetchPypi, plugins ? [ ] }:

python3.pkgs.buildPythonApplication rec {
  pname = "instawow";
  version = "v3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "layday";
    repo = pname;
    rev = version;
    sha256 = "sha256-eBpX+ojlrWwRXuMijnmb4lNlxIJ40Q9RUqS6txPBDiM=";
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
