// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ngon Sac Viet';

  @override
  String get tabTranslate => 'Translate';

  @override
  String get tabHeritage => 'Heritage';

  @override
  String get tabLearn => 'Learn';

  @override
  String get tabContribute => 'Contribute';

  @override
  String get settings => 'Settings';

  @override
  String get login => 'Sign in';

  @override
  String get logout => 'Sign out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get displayName => 'Display name';

  @override
  String get register => 'Create account';

  @override
  String get haveAccount => 'I already have an account';

  @override
  String get needAccount => 'Create a new account';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get uiLanguage => 'App language';

  @override
  String get sourceLanguage => 'From';

  @override
  String get targetLanguage => 'To';

  @override
  String get enterText => 'Enter a short sentence';

  @override
  String get translate => 'Translate';

  @override
  String get result => 'Result';

  @override
  String get warnings => 'Notes';

  @override
  String get pickImage => 'Read text from a photo';

  @override
  String get ocrUnavailable =>
      'On-device text recognition runs on Android and iOS. Type the sentence here, or use the API image route from a phone build.';

  @override
  String get ocrEmpty => 'No text was found in that photo.';

  @override
  String get contributeTitle => 'Contribute a checked sentence';

  @override
  String get sourceText => 'Ethnic-language sentence';

  @override
  String get targetText => 'Vietnamese or English meaning';

  @override
  String get note => 'Where this pair was checked';

  @override
  String get saveLocal => 'Save on this device';

  @override
  String get sync => 'Sync';

  @override
  String get online => 'Synced with the server.';

  @override
  String get offlineSaved =>
      'Saved on this device. It will upload the next time the server is reachable.';

  @override
  String get pending => 'Waiting for review';

  @override
  String get quiz => 'Quiz';

  @override
  String get submit => 'Submit';

  @override
  String scoreLabel(int score, int total) {
    return '$score / $total';
  }

  @override
  String get emptyLessons => 'Lessons appear after the first sync.';

  @override
  String get emptyPeoples => 'No peoples in the local catalog yet.';

  @override
  String get phraseNote =>
      'Example sentences appear only after a reviewer approves them. This lesson does not invent phrases.';

  @override
  String get account => 'Account';

  @override
  String get loading => 'Loading';

  @override
  String get languageFamily => 'Language family';

  @override
  String get region => 'Region';

  @override
  String get origin => 'Language origin';
}
