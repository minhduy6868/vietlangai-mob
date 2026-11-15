# Build Flutter app under /app and publish static landing at site root.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$apiBase = if ($env:API_BASE) { $env:API_BASE } else { "https://api.ngonsacviet.ourvibe.tech" }

Write-Host "== flutter build web (/app) =="
flutter build web --release `
  --base-href /app/ `
  --dart-define="API_BASE=$apiBase"

$apkSrc = Join-Path $root "build\app\outputs\flutter-apk\app-release.apk"
$apkDestDir = Join-Path $root "landing\downloads"
$apkDest = Join-Path $apkDestDir "ngonsacviet-arm64.apk"
if (-not (Test-Path $apkSrc)) {
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

# SPA fallback for Flutter routes under /app
@(
  "/*    /index.html   200",
  "/app/*    /app/index.html   200"
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

Write-Host "== wrangler pages deploy =="
npx --yes wrangler pages deploy $dist --project-name=ngonsacviet --branch=main --commit-dirty=true
Write-Host "Done. https://ngonsacviet.ourvibe.tech/"
Write-Host "APK:  https://ngonsacviet.ourvibe.tech/downloads/ngonsacviet-arm64.apk"
