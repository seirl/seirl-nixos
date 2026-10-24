{ lib, python3, fetchFromGitHub, plugins ? [ ] }:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "instawow";
  version = "7.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "layday";
    repo = "instawow";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-NJDx1eUj+0Vq61lmR0y8R+H6sV8ajUFIpBrWzw2vATA=";
  };

  extras = [ ];  # Disable GUI, most dependencies are not packaged.

  postPatch = ''
    cat >> pyproject.toml <<EOF

    [tool.versioningit]
    default-version = "${finalAttrs.version}"
    EOF
  '';

  # The versions available in nixpkgs don't match the ones requested exactly.
  pythonRelaxDeps = [
    "aiohttp"
    "rapidfuzz"
  ];

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    versioningit
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
    loguru
    packaging
    pluggy
    prompt-toolkit
    rapidfuzz
    truststore
    typing-extensions
    wcwidth
    yarl
  ] ++ plugins;

  meta = with lib; {
    homepage = "https://github.com/layday/instawow";
    description = "World of Warcraft add-on manager CLI and GUI";
    mainProgram = "instawow";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seirl ];
  };
})
