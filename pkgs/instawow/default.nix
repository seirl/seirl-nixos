{ lib, python3, fetchFromGitHub, plugins ? [ ] }:

python3.pkgs.buildPythonApplication rec {
  pname = "instawow";
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "layday";
    repo = "instawow";
    tag = "v${version}";
    sha256 = "sha256-dT1oiPX+id0g28I9I/WJS9G6hyeHHGx5mWvNKXX1Wus=";
  };

  extras = [ ];  # Disable GUI, most dependencies are not packaged.

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];
  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    # Fix for broken aiohttp-client-cache. PR #441704
    (aiohttp-client-cache.overridePythonAttrs (old: {
      doCheck = false;
    }))
    attrs
    cattrs
    click
    diskcache
    iso8601
    loguru
    packaging
    pluggy
    prompt-toolkit
    rapidfuzz
    truststore
    typing-extensions
    yarl
  ] ++ plugins;

  meta = with lib; {
    homepage = "https://github.com/layday/instawow";
    description = "World of Warcraft add-on manager CLI and GUI";
    mainProgram = "instawow";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
}
