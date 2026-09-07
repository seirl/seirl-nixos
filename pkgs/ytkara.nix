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
  version = "0-unstable-2026-09-08";

  src = fetchFromGitHub {
    owner = "Zeletochoy";
    repo = "yt-kara";
    rev = "8ec4172d2d70c4a34b1b8f8532a1d9cd0231b9b0";
    sha256 = "sha256-D2EOV35onhAZLmLJrtTIr8QCyePxDlREdQEDApAi/JA=";
  };

  npmDepsHash = "sha256-F2EVGjOrQWdx/wHqDjrr4roMoCzZlK4P2rfCYq/HpwI=";

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

