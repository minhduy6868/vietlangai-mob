import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionProfile {
  const SessionProfile({this.displayName, this.email});

  final String? displayName;
  final String? email;

  bool get isSignedIn =>
      (displayName != null && displayName!.trim().isNotEmpty) ||
      (email != null && email!.trim().isNotEmpty);

  String get initials {
    final source = (displayName?.trim().isNotEmpty == true ? displayName! : email ?? '').trim();
    if (source.isEmpty) return '?';
    final parts = source.split(RegExp(r'\s+|@')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return source.substring(0, source.length >= 2 ? 2 : 1).toUpperCase();
  }

  String get label {
    if (displayName != null && displayName!.trim().isNotEmpty) return displayName!.trim();
    if (email != null && email!.trim().isNotEmpty) return email!.trim();
    return 'Khách';
  }
}

class SessionProfileStore {
  SessionProfileStore(this._prefs);

  final SharedPreferences _prefs;

  SessionProfile read() {
    return SessionProfile(
      displayName: _prefs.getString('profile_display_name'),
      email: _prefs.getString('profile_email'),
    );
  }

  Future<void> save({String? displayName, String? email}) async {
    if (displayName != null) {
      await _prefs.setString('profile_display_name', displayName.trim());
    }
    if (email != null) {
      await _prefs.setString('profile_email', email.trim());
    }
  }

  Future<void> clear() async {
    await _prefs.remove('profile_display_name');
    await _prefs.remove('profile_email');
  }
}

final sessionProfileStoreProvider = Provider<SessionProfileStore>(
  (ref) => throw StateError('SessionProfileStore is missing'),
);

final sessionProfileProvider = NotifierProvider<SessionProfileNotifier, SessionProfile>(
  SessionProfileNotifier.new,
);

class SessionProfileNotifier extends Notifier<SessionProfile> {
  @override
  SessionProfile build() => ref.watch(sessionProfileStoreProvider).read();

  Future<void> save({String? displayName, String? email}) async {
    await ref.read(sessionProfileStoreProvider).save(displayName: displayName, email: email);
    state = ref.read(sessionProfileStoreProvider).read();
  }

  Future<void> clear() async {
    await ref.read(sessionProfileStoreProvider).clear();
    state = const SessionProfile();
  }
}
