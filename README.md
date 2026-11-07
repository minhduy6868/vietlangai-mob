# Flutter

Clean architecture: `domain` (model, use case), `data` (SQLite, API, Supabase, OCR), `ui` (view và Notifier).

- Material 3, sáng/tối, tiếng Việt và tiếng Anh qua ARB.
- `go_router` cho bốn tab: Dịch, Di sản, Học, Đóng góp.
- Model sinh bằng freezed. Sau khi đổi model: `dart run build_runner build`.
- Máy lưu catalog và câu đóng góp trước. `SyncUseCase` kéo catalog và đẩy câu chờ khi có mạng.
- OCR trên máy: ML Kit, Latin, Android/iOS. Web và Windows không nhận diện ảnh tại chỗ.
- Supabase anon key chỉ để đọc catalog. Đăng nhập và gửi câu đi qua API.

`flutter test` kiểm tra đồng bộ offline, không giữ đáp án quiz, và tab Dịch mở được.
