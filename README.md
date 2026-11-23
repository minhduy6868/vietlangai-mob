# Ngôn Sắc Việt — Flutter (Web + Mobile)

Clean architecture: `domain` (model, use case), `data` (SQLite, API, Supabase, OCR), `ui` (view và Notifier).

## Nền tảng

- **Flutter Web** + **Android/iOS/Windows** dùng chung một codebase.
- Landing marketing: thư mục `landing/` (HTML/CSS/JS), deep-link vào `/app/#/...`.
- Material 3, sáng/tối, tiếng Việt và tiếng Anh qua ARB.
- `go_router`: Welcome, Login, Register, bốn tab (Dịch, Di sản, Học, Đóng góp), Settings.
- Auth gọi **cùng FastAPI** (`/v1/auth/*`). Token lưu bằng `flutter_secure_storage`.
- Supabase anon key chỉ để đọc catalog. Đăng nhập và gửi câu đi qua API.

## Authentication

| Màn hình | Route (web: `/app/...`) |
|----------|--------|
| Dịch (khách) | `/translate` |
| Đăng nhập | `/login` |
| Đăng ký | `/register` |
| Cài đặt (đăng xuất) | `/settings` |

Luồng phiên:

1. App mở → `AuthSession` đọc token trong secure storage.
2. Gọi `GET /v1/auth/me`; nếu 401 thì `POST /v1/auth/refresh`.
3. Thành công → `authenticated`; thất bại → xóa token → `unauthenticated`.
4. Dio interceptor tự refresh một lần khi gặp HTTP 401 (trừ endpoint auth).
5. Đăng xuất → `POST /v1/auth/logout` (best-effort) + xóa token local.

## Chạy local

```powershell
# API (terminal khác)
cd ..\vietlangai-backend
.\.venv\Scripts\uvicorn.exe app.main:app --reload --port 8000

# Flutter
cd ..\vietlangai-mob
flutter pub get
flutter run -d chrome --dart-define=API_BASE=http://127.0.0.1:8000
# hoặc
flutter run --dart-define=API_BASE=http://127.0.0.1:8000
```

Biến compile-time:

- `API_BASE` — mặc định `http://127.0.0.1:8000`
- `SUPABASE_URL`, `SUPABASE_ANON_KEY` — tùy chọn, catalog
- `GOOGLE_CLIENT_ID` — tùy chọn, Google Sign-In

Landing tĩnh (dev): mở `landing/index.html` qua static server của deploy, hoặc serve cùng bản web.

## Test

```powershell
flutter test
```

Gồm kiểm tra đồng bộ offline, tab Dịch, và validation form auth (`test/auth_validation_test.dart`).
