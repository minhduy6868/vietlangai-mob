"""
Unified local server:
  http://127.0.0.1:5500/       → landing/
  http://127.0.0.1:5500/app/   → build/web/  (Flutter)

Login/Register then work as /app/login and /app/register (path URLs).

Prereq:
  flutter build web --dart-define=API_BASE=http://127.0.0.1:8000 --base-href /app/

Usage:
  python scripts/serve_landing_dev.py
"""

from __future__ import annotations

import argparse
import mimetypes
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import unquote, urlparse


ROOT = Path(__file__).resolve().parents[1]
LANDING = ROOT / "landing"
FLUTTER_WEB = ROOT / "build" / "web"


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt: str, *args) -> None:
        print("[%s] %s" % (self.log_date_time_string(), fmt % args))

    def do_GET(self):  # noqa: N802
        parsed = urlparse(self.path)
        path = unquote(parsed.path)

        if path == "/app":
            self.send_response(302)
            self.send_header("Location", "/app/")
            self.end_headers()
            return

        if path.startswith("/app/"):
            rel = path[len("/app/") :]
            return self._serve_file(FLUTTER_WEB, rel, fallback_index=True)

        rel = path.lstrip("/")
        return self._serve_file(LANDING, rel, fallback_index=True)

    def _serve_file(self, root: Path, rel: str, fallback_index: bool) -> None:
        if not root.exists():
            self.send_error(
                503,
                "Flutter web build missing. Run: flutter build web --base-href /app/",
            )
            return

        candidate = (root / rel).resolve() if rel else root.resolve()
        try:
            candidate.relative_to(root.resolve())
        except ValueError:
            self.send_error(403, "Forbidden")
            return

        if candidate.is_dir():
            candidate = candidate / "index.html"

        if (not candidate.exists() or not candidate.is_file()) and fallback_index:
            # SPA fallback for Flutter routes under /app/
            if root == FLUTTER_WEB:
                candidate = root / "index.html"

        if not candidate.exists() or not candidate.is_file():
            self.send_error(404, "File not found")
            return

        content_type = mimetypes.guess_type(str(candidate))[0] or "application/octet-stream"
        data = candidate.read_bytes()
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", "no-cache")
        self.end_headers()
        self.wfile.write(data)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=5500)
    parser.add_argument("--host", default="127.0.0.1")
    args = parser.parse_args()

    if not FLUTTER_WEB.exists():
        print("WARNING: build/web not found.")
        print("  cd vietlangai-mob")
        print("  flutter build web --dart-define=API_BASE=http://127.0.0.1:8000 --base-href /app/")

    server = ThreadingHTTPServer((args.host, args.port), Handler)
    print(f"Landing:  http://{args.host}:{args.port}/")
    print(f"App:      http://{args.host}:{args.port}/app/translate")
    print(f"Login:    http://{args.host}:{args.port}/app/login")
    print(f"Register: http://{args.host}:{args.port}/app/register")
    print("Ctrl+C to stop")
    server.serve_forever()


if __name__ == "__main__":
    main()
