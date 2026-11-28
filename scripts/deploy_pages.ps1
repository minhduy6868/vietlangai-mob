# Build Flutter app under /app and publish static landing at site root.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$apiBase = if ($env:API_BASE) { $env:API_BASE } else { "https://ngonsacviet.ourvibe.tech" }
$ec2Origin = if ($env:EC2_ORIGIN) { $env:EC2_ORIGIN } else { "http://ec2-3-26-79-228.ap-southeast-2.compute.amazonaws.com" }

Write-Host "== flutter build web (/app) =="
flutter build web --release `
  --base-href /app/ `
  --dart-define="API_BASE=$apiBase"

$apkSrc = Join-Path $root "build\app\outputs\flutter-apk\app-release.apk"
$apkDestDir = Join-Path $root "landing\downloads"
$apkDest = Join-Path $apkDestDir "ngonsacviet-arm64.apk"
if (-not (Test-Path $apkSrc) -and -not (Test-Path $apkDest) -and $env:SKIP_APK -ne '1') {
  Write-Host "== flutter build apk (arm64) =="
  $env:GRADLE_USER_HOME = if ($env:GRADLE_USER_HOME) { $env:GRADLE_USER_HOME } else { "D:\tool\gradle-home" }
  flutter build apk --release --target-platform=android-arm64 --dart-define="API_BASE=$apiBase"
}
if (Test-Path $apkSrc) {
  New-Item -ItemType Directory -Force -Path $apkDestDir | Out-Null
  Copy-Item -Force $apkSrc $apkDest
  $mb = [math]::Round((Get-Item $apkDest).Length / 1MB, 2)
  Write-Host "APK ready: $apkDest ($mb MB)"
} else {
  Write-Warning "No APK found; site will deploy without /downloads/ngonsacviet-arm64.apk"
}

$dist = Join-Path $root "build\site"
if (Test-Path $dist) { Remove-Item -Recurse -Force $dist }
New-Item -ItemType Directory -Force -Path (Join-Path $dist "app") | Out-Null

Copy-Item -Recurse -Force (Join-Path $root "landing\*") $dist
Copy-Item -Recurse -Force (Join-Path $root "build\web\*") (Join-Path $dist "app")

# SPA fallback for Flutter routes under /app (must precede root wildcard)
@(
  "/app/*    /app/index.html   200",
  "/*    /index.html   200"
) | Set-Content -Path (Join-Path $dist "_redirects") -Encoding ascii

@"
/*
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin

/assets/*
  Cache-Control: public, max-age=31536000, immutable

/app/assets/*
  Cache-Control: public, max-age=31536000, immutable

/app/canvaskit/*
  Cache-Control: public, max-age=31536000, immutable

/downloads/*.apk
  Content-Type: application/vnd.android.package-archive
  Content-Disposition: attachment
  Cache-Control: public, max-age=3600
"@ | Set-Content -Path (Join-Path $dist "_headers") -Encoding ascii

$workerJs = @"
const ORIGIN = '$ec2Origin';

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // Proxy API and health checks over HTTPS to EC2 backend
    if (url.pathname.startsWith('/v1/') || url.pathname === '/health') {
      const target = new URL(url.pathname + url.search, ORIGIN);
      const headers = new Headers(request.headers);
      headers.delete('host');
      const init = {
        method: request.method,
        headers,
        redirect: 'manual',
      };
      if (request.method !== 'GET' && request.method !== 'HEAD') {
        init.body = request.body;
      }
      return fetch(target.toString(), init);
    }

    const res = await env.ASSETS.fetch(request);
    if (res.status === 404) {
      const last = url.pathname.split('/').pop() || '';
      if (!last.includes('.')) {
        if (url.pathname.startsWith('/app')) {
          return env.ASSETS.fetch(new URL('/app/', url.origin));
        }
        return env.ASSETS.fetch(new URL('/', url.origin));
      }
    }
    return res;
  },
};
"@
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText((Join-Path $dist "_worker.js"), $workerJs.Replace("`r`n", "`n"), $utf8NoBom)

Write-Host "== wrangler pages deploy =="
npx --yes wrangler pages deploy $dist --project-name=ngonsacviet --branch=main --commit-dirty=true
Write-Host "Done. https://ngonsacviet.ourvibe.tech/"
Write-Host "APK:  https://ngonsacviet.ourvibe.tech/downloads/ngonsacviet-arm64.apk"
