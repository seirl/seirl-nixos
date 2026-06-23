{ lib
, buildNpmPackage
, makeWrapper
, yt-dlp
, ffmpeg-headless
, nodejs
, cloudflared
, fetchFromGitHub
}:

buildNpmPackage {
  pname = "yt-kara";
  version = "0-unstable-2026-06-24";

  src = fetchFromGitHub {
    owner = "seirl";
    repo = "yt-kara";
    rev = "c45a08280551c2015ad100d505689e14d2ef3008";
    sha256 = "sha256-SG5eGdbwRP52CMI96zB8eM5V7yM7gsnDfhae/5PHKvg=";
  };

  npmDepsHash = "sha256-o9uLuNGg4yKBaVEINtUZJEa4VVak2KJeHvCsu8TiRq0=";

  # Skip Puppeteer's automatic Chrome download during npm install.
  # The Nix sandbox has no network access, so this download would fail.
  PUPPETEER_SKIP_DOWNLOAD = "1";

  # We don't have a build step (we run the JS files directly),
  # so we tell Nix to skip running 'npm run build'.
  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # Wrap the executable to inject runtime dependencies into PATH
    # and ensure the temporary writable data directory exists before startup
    # to prevent Node's mkdirSync from crashing on the broken symlink.
    wrapProgram $out/bin/yt-kara \
      --run "mkdir -p /tmp/yt-kara-data" \
      --set CLOUDFLARED_BIN "${cloudflared}/bin/cloudflared" \
      --prefix PATH : ${lib.makeBinPath [ yt-dlp ffmpeg-headless nodejs ]}
  '';

  meta = with lib; {
    description = "YT-Kara - Karaoke webapp for parties using YouTube videos";
    homepage = "https://github.com/zeletochoy/yt-kara";
    license = licenses.mit;
    maintainers = with maintainers; [ seirl ];
    platforms = platforms.all;
  };
}

