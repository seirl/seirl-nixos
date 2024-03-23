{ lib, python3, fetchFromGitHub, fetchPypi, plugins ? [ ] }:

python3.pkgs.buildPythonApplication rec {
  pname = "instawow";
  version = "v3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "layday";
    repo = pname;
    rev = version;
    sha256 = "sha256-eBXUg5qLTmalWbTh5/iJ8yliTgv+HoTuGhGkd3y3CBA=";
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
    diskcache
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
