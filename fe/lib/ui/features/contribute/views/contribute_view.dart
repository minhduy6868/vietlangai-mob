import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../../../domain/models/models.dart';
import '../../../app_providers.dart';
import '../../settings/view_models/settings_view_model.dart';

class ContributeView extends ConsumerStatefulWidget {
  const ContributeView({super.key});

  @override
  ConsumerState<ContributeView> createState() => _ContributeViewState();
}

class _ContributeViewState extends ConsumerState<ContributeView> {
  final _sourceController = TextEditingController();
  final _targetController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedLanguageCode;
  bool _saving = false;
  bool _reminderEnabled = true;

  final List<Map<String, dynamic>> _offlinePacks = [
    {
      'title': 'Tiếng M\'nông',
      'size': '12.4 MB',
      'status': 'downloaded', // downloaded, available
      'updated': '10/2026',
    },
    {
      'title': 'Tiếng Ba Na',
      'size': '15.8 MB',
      'status': 'available',
      'updated': 'Mới cập nhật',
    },
    {
      'title': 'Tiếng Chăm (Akhar Thrah)',
      'size': '18.2 MB',
      'status': 'available',
      'updated': 'Sắp ra mắt',
    },
  ];

  @override
  void dispose() {
    _sourceController.dispose();
    _targetController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;
    final settings = ref.watch(settingsViewModelProvider);
    final languagesAsync = ref.watch(languagesProvider);
    final savedContributions = ref.watch(contributionsProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. User Profile Header Card (Figma Style)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                      child: Text(
                        'NL',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AC0D),
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.cardTheme.color ?? Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.star_rounded, size: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Nguyễn Thị Nhã Lan',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.verified_rounded, size: 16, color: Color(0xFFD4AC0D)),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Thành viên tích cực bảo tồn • Cấp độ 3',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // 2. Community Conservation Campaign Card (Figma Style)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF2C1613), const Color(0xFF1B1B1F)]
                  : [const Color(0xFF8B261E), const Color(0xFF6B1D16)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B261E).withValues(alpha: isDark ? 0.3 : 0.2),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AC0D).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'CHIẾN DỊCH CỘNG ĐỒNG',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFFD54F),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.volunteer_activism_rounded, color: Colors.white70, size: 18),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Chung tay bảo tồn tiếng Ba Na',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Mỗi bản ghi âm đóng góp là một viên gạch xây dựng kho tàng ngôn ngữ cho thế hệ mai sau.',
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.65,
                        minHeight: 6,
                        backgroundColor: Colors.white24,
                        color: Color(0xFFFFD54F),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '65%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '65.230 / 100.000 từ đã số hóa',
                style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF8B261E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: () => _showContributeModal(context, languagesAsync, locale, l10n),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                label: const Text(
                  'Đóng góp câu mới',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 3. Offline Dictionaries Section ("Gói từ điển ngoại tuyến")
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gói từ điển ngoại tuyến',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const Icon(Icons.download_for_offline_outlined, size: 18),
          ],
        ),
        const SizedBox(height: 8),

        for (final pack in _offlinePacks)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: pack['status'] == 'downloaded'
                      ? Colors.green.withValues(alpha: 0.12)
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  pack['status'] == 'downloaded'
                      ? Icons.check_circle_rounded
                      : Icons.file_download_outlined,
                  size: 20,
                  color: pack['status'] == 'downloaded'
                      ? Colors.green
                      : theme.colorScheme.primary,
                ),
              ),
              title: Text(
                pack['title'],
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              subtitle: Text(
                '${pack['size']} • ${pack['status'] == 'downloaded' ? 'Đã tải về' : 'Chưa tải'}',
                style: TextStyle(
                  fontSize: 11.5,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              trailing: pack['status'] == 'downloaded'
                  ? const Text(
                      'Sẵn sàng',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green),
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onPressed: () {
                        setState(() => pack['status'] = 'downloaded');
                        _show('Đã tải thành công gói từ điển: ${pack['title']}');
                      },
                      child: const Text('Tải về', style: TextStyle(fontSize: 12)),
                    ),
            ),
          ),
        const SizedBox(height: 18),

        // 4. Quick Settings Section ("Cài đặt nhanh")
        Text(
          'Cài đặt nhanh',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 8),

        Card(
          child: Column(
            children: [
              SwitchListTile(
                value: _reminderEnabled,
                onChanged: (val) {
                  setState(() => _reminderEnabled = val);
                  _show(_reminderEnabled ? 'Đã bật nhắc học 20:00' : 'Đã tắt nhắc nhở');
                },
                title: const Text('Nhắc nhở học tập', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: const Text('20:00 hàng ngày', style: TextStyle(fontSize: 12)),
                secondary: const Icon(Icons.notifications_active_outlined),
              ),
              const Divider(height: 1),
              SwitchListTile(
                value: settings.themeMode == ThemeMode.dark,
                onChanged: (val) {
                  ref.read(settingsViewModelProvider.notifier).setTheme(
                        val ? ThemeMode.dark : ThemeMode.light,
                      );
                },
                title: const Text('Giao diện tối (Dark mode)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text(
                  settings.themeMode == ThemeMode.dark ? 'Đang bật' : 'Đang tắt',
                  style: const TextStyle(fontSize: 12),
                ),
                secondary: const Icon(Icons.dark_mode_outlined),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 5. Local Contributions History
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Câu đã đóng góp trên máy',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () => _showContributeModal(context, languagesAsync, locale, l10n),
            ),
          ],
        ),
        const SizedBox(height: 6),

        savedContributions.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('$error'),
          data: (rows) {
            if (rows.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Bạn chưa có câu đóng góp nào trên máy này.',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: [
                for (final row in rows)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(row.sourceText, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${row.targetText}\nTrạng thái: ${row.status == 'pending' ? 'Chờ duyệt' : row.status}'),
                      isThreeLine: true,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showContributeModal(
    BuildContext context,
    AsyncValue<List<Language>> languagesAsync,
    String locale,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Đóng góp câu đối chiếu',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    languagesAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (error, _) => Text('$error'),
                      data: (rows) {
                        final ethnic = rows.where((row) => row.role == 'ethnic').toList();
                        if (ethnic.isEmpty) return Text(l10n.emptyPeoples);
                        _selectedLanguageCode ??= ethnic.first.code;
                        return DropdownButtonFormField<String>(
                          value: _selectedLanguageCode,
                          decoration: const InputDecoration(labelText: 'Ngôn ngữ dân tộc'),
                          items: [
                            for (final row in ethnic)
                              DropdownMenuItem(
                                value: row.code,
                                child: Text(locale == 'vi' ? row.nameVi : row.nameEn),
                              ),
                          ],
                          onChanged: (value) => setModalState(() => _selectedLanguageCode = value),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _sourceController,
                      decoration: InputDecoration(
                        labelText: l10n.sourceText,
                        hintText: 'Ví dụ: Kơi nyơh lĭ oas?',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _targetController,
                      decoration: InputDecoration(
                        labelText: l10n.targetText,
                        hintText: 'Ví dụ: Bạn có khỏe không?',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: l10n.note,
                        hintText: 'Ví dụ: Người già làng Buôn Đôn xác nhận',
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _saving ? null : () async => _save(l10n),
                      child: Text(_saving ? l10n.loading : l10n.saveLocal),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _save(AppLocalizations l10n) async {
    final language = _selectedLanguageCode;
    final source = _sourceController.text.trim();
    final target = _targetController.text.trim();
    if (language == null || source.isEmpty || target.isEmpty) {
      _show('Vui lòng điền đầy đủ câu nguồn và câu đích');
      return;
    }
    setState(() => _saving = true);
    final row = Contribution(
      clientId: const Uuid().v4(),
      languageCode: language,
      sourceLang: language,
      targetLang: 'vi',
      sourceText: source,
      targetText: target,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      status: 'pending',
    );
    await ref.read(localStoreProvider).saveContribution(row);
    ref.invalidate(contributionsProvider);
    if (mounted) {
      setState(() {
        _sourceController.clear();
        _targetController.clear();
        _noteController.clear();
        _saving = false;
      });
      Navigator.of(context, rootNavigator: true).pop();
      _show(l10n.offlineSaved);
    }
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
