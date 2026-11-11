# Cloudflare Pages — Ngôn Sắc Việt

## Architecture

- `/` — static marketing landing (`fe/landing/`)
- `/app/` — Flutter web app

## Deploy

```powershell
cd fe
.\scripts\deploy_pages.ps1
```

Or manually:

```powershell
flutter build web --release --base-href /app/ `
  --dart-define=API_BASE=https://api.ngonsacviet.ourvibe.tech `
  --dart-define=GOOGLE_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com

# Then assemble build/site = landing + build/web as /app and:
npx wrangler pages deploy build/site --project-name=ngonsacviet --branch=main
```

Live: https://ngonsacviet.ourvibe.tech
