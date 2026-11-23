import 'package:flutter_test/flutter_test.dart';
import 'package:ngon_sac_viet/ui/features/auth/auth_validation.dart';

void main() {
  group('AuthValidation', () {
    test('email requires value and valid format', () {
      expect(AuthValidation.email(''), isNotNull);
      expect(AuthValidation.email('abc'), isNotNull);
      expect(AuthValidation.email('user@example.com'), isNull);
    });

    test('password enforces length and strength for register', () {
      expect(AuthValidation.password(''), isNotNull);
      expect(AuthValidation.password('short'), isNotNull);
      expect(AuthValidation.password('password'), isNull);
      expect(
        AuthValidation.password('password', requireStrong: true),
        isNotNull,
      );
      expect(
        AuthValidation.password('password1', requireStrong: true),
        isNull,
      );
    });

    test('confirm password must match', () {
      expect(AuthValidation.confirmPassword('abc12345', ''), isNotNull);
      expect(AuthValidation.confirmPassword('abc12345', 'abc12346'), isNotNull);
      expect(AuthValidation.confirmPassword('abc12345', 'abc12345'), isNull);
    });

    test('display name and terms', () {
      expect(AuthValidation.displayName(''), isNotNull);
      expect(AuthValidation.displayName('Nguyễn Văn A'), isNull);
      expect(AuthValidation.termsAccepted(false), isNotNull);
      expect(AuthValidation.termsAccepted(true), isNull);
    });
  });
}
