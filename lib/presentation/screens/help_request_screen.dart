import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import '../blocs/help_request_cubit.dart';
import '../widgets/help_request_card.dart';
import '../widgets/comment_widget.dart';
import '../themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/enums/emergency_level.dart';
import '../../core/enums/help_request_status.dart';
import '../localization/locale_keys.g.dart';
import '../../injection_container.dart';
import '../blocs/comment_cubit.dart';
import '../blocs/theme_cubit.dart';
import '../partials/base_app_bar.dart';
import '../../core/network/auth_service.dart';
import '../blocs/account_cubit.dart';
import '../screens/delete_confirmation_screen.dart';
import '../screens/edit_help_request_screen.dart';
import '../blocs/comment_cubit.dart';
import '../blocs/comment_cubit.dart';
import '../../data/models/comment_dto.dart';

class HelpRequestScreen extends StatefulWidget {
  final int requestId;
  const HelpRequestScreen({Key? key, required this.requestId}) : super(key: key);

  @override
  State<HelpRequestScreen> createState() => _HelpRequestScreenState();
}

class _HelpRequestScreenState extends State<HelpRequestScreen> {
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final authService = AuthService();
    final user = await authService.getUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HelpRequestCubit(sl())..getById(widget.requestId)),
        BlocProvider(create: (_) => CommentCubit(sl())..getByHelpRequestId(widget.requestId)),
      ],
      child: Scaffold(
        appBar: BaseAppBar(
          title: 'help_requests.detail_title'.tr(),
          showLogo: false,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return Icon(state.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode);
                  },
                ),
                tooltip: 'Change Theme',
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.translate),
                tooltip: 'help_requests.change_language'.tr(),
                onPressed: () {
                  final current = context.locale.languageCode;
                  final newLocale = current == 'tr' ? const Locale('en') : const Locale('tr');
                  context.setLocale(newLocale);
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<HelpRequestCubit, HelpRequestState>(
          builder: (context, state) {
            if (state is HelpRequestLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HelpRequestError) {
              return Center(child: Text('help_requests.error'.tr() + '\n' + state.error));
            } else if (state is HelpRequestDetailLoaded && state.helpRequest != null) {
              final req = state.helpRequest!;
              final theme = Theme.of(context);
              final colorScheme = theme.colorScheme;
              final emergencyColor = _emergencyColor(req.emergencyLevel, context);
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                children: [
                  // Başlık ve aciliyet
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: colorScheme.surface,
                        backgroundImage: (req.imageUrl != null && req.imageUrl!.isNotEmpty)
                            ? NetworkImage(req.imageUrl!)
                            : null,
                        child: (req.imageUrl == null || req.imageUrl!.isEmpty)
                            ? Icon(Icons.volunteer_activism, color: emergencyColor, size: 36)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _emergencyChip(context, req.emergencyLevel),
                                const SizedBox(width: 8),
                                _statusChip(context, req.status),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              req.title,
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              DateFormat('dd.MM.yyyy HH:mm').format(req.createdAt),
                              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Görsel
                  if (req.imageUrl != null && req.imageUrl!.isNotEmpty)
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: const EdgeInsets.all(12),
                                child: InteractiveViewer(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(
                                      req.imageUrl!,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/logo.png',
                                          fit: BoxFit.contain,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              req.imageUrl!,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/logo.png',
                                  height: 220,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding: const EdgeInsets.all(12),
                                    child: InteractiveViewer(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.network(
                                          req.imageUrl!,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/logo.png',
                                              fit: BoxFit.contain,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.zoom_out_map, color: Colors.white, size: 24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (req.imageUrl != null && req.imageUrl!.isNotEmpty)
                    const SizedBox(height: 18),
                  // Açıklama
                  Text(
                    req.description,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  // Konum ve iletişim
                  Row(
                    children: [
                      Icon(Icons.location_on, color: colorScheme.primary.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(req.location, style: theme.textTheme.bodyMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.person, color: colorScheme.secondary.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Expanded(child: Text(req.contactName ?? req.userName, style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.phone, color: colorScheme.secondary.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Expanded(child: Text(req.contactPhone ?? '-', style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.email, color: colorScheme.secondary.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Expanded(child: Text(req.contactEmail ?? '-', style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                  const SizedBox(height: 22),
                  // Eğer ilan sahibi ise düzenle ve sil butonları yorumlar başlığının üstünde
                  if (_user != null && req.userId == _user!['id']) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final req = state.helpRequest!;
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(value: context.read<HelpRequestCubit>()),
                                      BlocProvider.value(value: context.read<AccountCubit>()),
                                    ],
                                    child: EditHelpRequestScreen(helpRequest: req),
                                  ),
                                ),
                              );
                              if (result == true && context.mounted) {
                                await context.read<HelpRequestCubit>().getById(req.id);
                                setState(() {});
                              }
                            },
                            icon: const Icon(Icons.edit, size: 20),
                            label: Text('help_requests.edit'.tr()),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.primary,
                              side: BorderSide(color: Theme.of(context).colorScheme.primary),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final req = state.helpRequest!;
                              debugPrint('[DELETE] Silme butonuna tıklandı. ID: ${req.id}');
                              final confirm = await Navigator.of(context).push<bool>(
                                MaterialPageRoute(
                                  builder: (_) => DeleteConfirmationScreen(
                                    title: 'help_requests.delete'.tr(),
                                    description: 'help_requests.delete_confirm_desc'.tr(),
                                    onConfirm: () async {
                                      try {
                                        final accountState = context.read<AccountCubit>().state;
                                        String? token;
                                        if (accountState is AccountSuccess) {
                                          token = accountState.response.token;
                                        }
                                        debugPrint('[DELETE] Token: ${token}');
                                        if (token == null) throw Exception('Oturum bulunamadı!');
                                        debugPrint('[DELETE] Silme isteği gönderiliyor...');
                                        await context.read<HelpRequestCubit>().delete(req.id, token);
                                        debugPrint('[DELETE] Silme isteği başarılı.');
                                        if (context.mounted) {
                                          Navigator.of(context).pop(true);
                                        }
                                      } catch (e) {
                                        debugPrint('[DELETE] Hata: ${e.toString()}');
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('help_requests.delete_failed'.tr(args: [e.toString()]))),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              );
                              debugPrint('[DELETE] Onay ekranı kapandı, confirm: ${confirm}');
                              if (confirm == true && context.mounted) {
                                debugPrint('[DELETE] Detay ekranı kapatılıyor.');
                                Navigator.of(context).pop(true);
                              }
                            },
                            icon: const Icon(Icons.delete, size: 20),
                            label: Text('help_requests.delete'.tr()),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                  ],
                  // Yorumlar başlığı
                  Text('help_requests.comments'.tr(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, commentState) {
                      if (commentState is CommentLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (commentState is CommentError) {
                        return Center(child: Text('help_requests.comments_failed'.tr() + ': ' + commentState.error));
                      } else if (commentState is CommentLoaded) {
                        if (commentState.comments.isEmpty) {
                          return Text('help_requests.no_comments'.tr());
                        }
                        return Column(
                          children: commentState.comments.map<Widget>((c) => CommentWidget(
                            userName: c.userName ?? c.userId.toString(),
                            date: DateFormat('dd.MM.yyyy HH:mm').format(c.createdAt),
                            comment: c.content,
                            isVeterinarian: c.veterinarianId != null,
                            isOwnComment: _user != null && c.userId == _user!['id'],
                            onDelete: _user != null && c.userId == _user!['id']
                                ? () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Yorumu Sil'),
                                        content: Text('Bu yorumu silmek istediğinize emin misiniz?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(ctx).pop(false),
                                            child: Text('Vazgeç'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(ctx).pop(true),
                                            child: Text('Sil', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      final accountState = context.read<AccountCubit>().state;
                                      if (accountState is! AccountSuccess) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('help_requests.login_required'.tr())),
                                        );
                                        return;
                                      }
                                      final token = accountState.response.token;
                                      await context.read<CommentCubit>().delete(c.id, token);
                                      await context.read<CommentCubit>().getByHelpRequestId(widget.requestId);
                                    }
                                  }
                                : null,
                            onEdit: _user != null && c.userId == _user!['id']
                                ? () async {
                                    final controller = TextEditingController(text: c.content);
                                    final result = await showDialog<String>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Yorumu Düzenle'),
                                        content: TextField(
                                          controller: controller,
                                          minLines: 2,
                                          maxLines: 5,
                                          decoration: InputDecoration(hintText: 'Yorumunuzu düzenleyin'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(ctx).pop(),
                                            child: Text('Vazgeç'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
                                            child: Text('Kaydet'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (result != null && result.isNotEmpty && result != c.content) {
                                      final accountState = context.read<AccountCubit>().state;
                                      if (accountState is! AccountSuccess) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('help_requests.login_required'.tr())),
                                        );
                                        return;
                                      }
                                      final token = accountState.response.token;
                                      final updated = CommentDto(
                                        id: c.id,
                                        helpRequestId: c.helpRequestId,
                                        userId: c.userId,
                                        userName: c.userName,
                                        veterinarianId: c.veterinarianId,
                                        veterinarianName: c.veterinarianName,
                                        content: result,
                                        createdAt: c.createdAt,
                                      );
                                      await context.read<CommentCubit>().add(updated, token);
                                      await context.read<CommentCubit>().getByHelpRequestId(widget.requestId);
                                    }
                                  }
                                : null,
                          )).toList(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 18),
                  // Yorum ekle alanı
                  Text('help_requests.add_comment'.tr(), style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _CommentInput(),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _emergencyLabel(EmergencyLevel level) {
    switch (level) {
      case EmergencyLevel.low:
        return 'help_requests.tab_low'.tr();
      case EmergencyLevel.medium:
        return 'help_requests.tab_medium'.tr();
      case EmergencyLevel.high:
        return 'help_requests.tab_high'.tr();
    }
  }

  String _statusLabel(HelpRequestStatus status) {
    switch (status) {
      case HelpRequestStatus.Active:
        return 'help_requests.status_active'.tr();
      case HelpRequestStatus.Passive:
        return 'help_requests.status_passive'.tr();
    }
  }

  Color _emergencyColor(EmergencyLevel level, BuildContext context) {
    switch (level) {
      case EmergencyLevel.high:
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.petsoliveDanger.withOpacity(0.85)
            : AppColors.petsoliveDanger;
      case EmergencyLevel.medium:
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.petsoliveWarning.withOpacity(0.85)
            : AppColors.petsoliveWarning;
      case EmergencyLevel.low:
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.petsoliveSuccess.withOpacity(0.85)
            : AppColors.petsoliveSuccess;
    }
    return Theme.of(context).colorScheme.primary.withOpacity(0.7);
  }

  Widget _emergencyChip(BuildContext context, EmergencyLevel level) {
    final color = _emergencyColor(level, context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Chip(
      label: Text(_emergencyLabel(level),
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isDark ? color.withOpacity(0.95) : color,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: isDark ? color.withOpacity(0.18) : color.withOpacity(0.13),
      side: BorderSide(color: color.withOpacity(0.45), width: 1.2),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      labelPadding: const EdgeInsets.only(left: 2, right: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _statusChip(BuildContext context, HelpRequestStatus status) {
    final s = status;
    final isOpen = s == HelpRequestStatus.Active || s == HelpRequestStatus.Passive;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isOpen
        ? (isDark ? Colors.greenAccent.shade200 : AppColors.petsoliveSuccess)
        : (isDark ? AppColors.bsGray400 : AppColors.bsGray700);
    final bgColor = isOpen
        ? (isDark ? Colors.greenAccent.withOpacity(0.22) : AppColors.petsoliveSuccess.withOpacity(0.18))
        : (isDark ? AppColors.bsGray700.withOpacity(0.22) : AppColors.bsGray300.withOpacity(0.22));
    return Chip(
      label: Text(_statusLabel(status),
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: bgColor,
      side: BorderSide(color: color.withOpacity(0.45), width: 1.1),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      labelPadding: const EdgeInsets.only(left: 2, right: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _CommentInput extends StatefulWidget {
  @override
  State<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<_CommentInput> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _isLoading = true);

    // Kullanıcı ve token al
    final accountState = context.read<AccountCubit>().state;
    if (accountState is! AccountSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('help_requests.login_required'.tr())),
      );
      setState(() => _isLoading = false);
      return;
    }
    final token = accountState.response.token;
    final user = accountState.response.user;

    // Yorum DTO'su oluştur
    final helpRequestId = context.findAncestorStateOfType<_HelpRequestScreenState>()?.widget.requestId;
    if (helpRequestId == null) {
      setState(() => _isLoading = false);
      return;
    }
    final dto = CommentDto(
      id: 0,
      helpRequestId: helpRequestId,
      userId: user.id,
      userName: user.username,
      content: text,
      createdAt: DateTime.now(),
      veterinarianId: null,
      veterinarianName: null,
    );

    try {
      await context.read<CommentCubit>().add(dto, token);
      // Yorumlar güncellensin
      await context.read<CommentCubit>().getByHelpRequestId(helpRequestId);
      _controller.clear();
      FocusScope.of(context).unfocus();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yorum eklenemedi: $e')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'help_requests.write_comment'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            minLines: 1,
            maxLines: 3,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
} 