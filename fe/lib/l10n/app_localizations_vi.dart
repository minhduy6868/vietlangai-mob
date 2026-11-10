// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Ngôn Sắc Việt';

  @override
  String get tabTranslate => 'Dịch';

  @override
  String get tabHeritage => 'Di sản';

  @override
  String get tabLearn => 'Học';

  @override
  String get tabContribute => 'Đóng góp';

  @override
  String get settings => 'Cài đặt';

  @override
  String get login => 'Đăng nhập';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get displayName => 'Tên hiển thị';

  @override
  String get register => 'Tạo tài khoản';

  @override
  String get haveAccount => 'Tôi đã có tài khoản';

  @override
  String get needAccount => 'Tạo tài khoản mới';

  @override
  String get theme => 'Giao diện';

  @override
  String get themeSystem => 'Theo máy';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get uiLanguage => 'Ngôn ngữ ứng dụng';

  @override
  String get sourceLanguage => 'Từ';

  @override
  String get targetLanguage => 'Sang';

  @override
  String get enterText => 'Nhập một câu ngắn';

  @override
  String get translate => 'Dịch';

  @override
  String get result => 'Kết quả';

  @override
  String get warnings => 'Ghi chú';

  @override
  String get pickImage => 'Đọc chữ từ ảnh';

  @override
  String get ocrUnavailable =>
      'Nhận dạng chữ trên máy chạy ở Android và iOS. Bạn có thể gõ câu, hoặc dùng bản điện thoại để gửi ảnh.';

  @override
  String get ocrEmpty => 'Không thấy chữ trong ảnh này.';

  @override
  String get contributeTitle => 'Đóng góp một câu đã đối chiếu';

  @override
  String get sourceText => 'Câu tiếng dân tộc';

  @override
  String get targetText => 'Nghĩa tiếng Việt hoặc tiếng Anh';

  @override
  String get note => 'Đã đối chiếu ở đâu';

  @override
  String get saveLocal => 'Lưu trên máy';

  @override
  String get sync => 'Đồng bộ';

  @override
  String get online => 'Đã đồng bộ với máy chủ.';

  @override
  String get offlineSaved =>
      'Đã lưu trên máy. Câu sẽ được gửi khi máy chủ truy cập được.';

  @override
  String get pending => 'Chờ rà soát';

  @override
  String get quiz => 'Kiểm tra';

  @override
  String get submit => 'Nộp bài';

  @override
  String scoreLabel(int score, int total) {
    return '$score / $total';
  }

  @override
  String get emptyLessons => 'Bài học hiện sau lần đồng bộ đầu tiên.';

  @override
  String get emptyPeoples => 'Máy chưa có danh sách dân tộc.';

  @override
  String get phraseNote =>
      'Câu mẫu chỉ hiện sau khi người rà soát duyệt. Bài học không tự bịa câu.';

  @override
  String get account => 'Tài khoản';

  @override
  String get loading => 'Đang tải';

  @override
  String get languageFamily => 'Họ ngôn ngữ';

  @override
  String get region => 'Địa bàn';

  @override
  String get origin => 'Nguồn gốc tiếng';
}
