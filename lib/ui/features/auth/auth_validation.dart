class AuthValidation {
  AuthValidation._();

  static final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Vui lòng nhập email.';
    if (!emailPattern.hasMatch(trimmed)) return 'Email không hợp lệ.';
    return null;
  }

  static String? password(String value, {bool requireStrong = false}) {
    if (value.isEmpty) return 'Vui lòng nhập mật khẩu.';
    if (value.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự.';
    if (requireStrong) {
      final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
      final hasDigit = RegExp(r'\d').hasMatch(value);
      if (!hasLetter || !hasDigit) {
        return 'Mật khẩu cần gồm chữ và số.';
      }
    }
    return null;
  }

  static String? confirmPassword(String password, String confirm) {
    if (confirm.isEmpty) return 'Vui lòng xác nhận mật khẩu.';
    if (password != confirm) return 'Mật khẩu xác nhận không khớp.';
    return null;
  }

  static String? displayName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Vui lòng nhập họ và tên.';
    if (trimmed.length > 120) return 'Họ và tên tối đa 120 ký tự.';
    return null;
  }

  static String? termsAccepted(bool accepted) {
    if (!accepted) return 'Bạn cần đồng ý điều khoản sử dụng.';
    return null;
  }
}
