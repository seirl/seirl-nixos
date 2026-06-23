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
  version = "0-unstable-2026-06-23";

  src = fetchFromGitHub {
    owner = "Zeletochoy";
    repo = "yt-kara";
    rev = "c842dd4adbe00ff3209a3c2e2d388dd59cdb5644";
    sha256 = "sha256-8jsEuFXCrHYQwN6iryGxlFiBNwnl6laCaDqjtrXC6H8=";
  };

  npmDepsHash = "sha256-D9ZCfep6mJgmsNnECf1mWNMBKIsMxYeAEgkG90lP2e0=";

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

