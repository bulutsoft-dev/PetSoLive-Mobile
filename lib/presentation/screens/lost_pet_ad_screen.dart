import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:petsolive/presentation/themes/colors.dart';
import '../../data/models/lost_pet_ad_dto.dart';
import '../partials/base_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/theme_cubit.dart';
import 'package:petsolive/data/providers/lost_pet_ad_api_service.dart';
import 'package:petsolive/data/providers/user_api_service.dart';
import 'package:petsolive/data/models/user_dto.dart';
import '../../data/local/session_manager.dart';
import 'edit_lost_pet_ad_screen.dart';
import 'delete_confirmation_screen.dart';
import '../blocs/lost_pet_ad_cubit.dart';
import '../../core/constants/admob_banner_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/admob_constants.dart';

class LostPetAdScreen extends StatefulWidget {
  final int adId;
  const LostPetAdScreen({Key? key, required this.adId}) : super(key: key);

  @override
  State<LostPetAdScreen> createState() => _LostPetAdScreenState();
}

class _LostPetAdScreenState extends State<LostPetAdScreen> {
  late Future<LostPetAdDto> _adFuture;
  Future<UserDto?>? _userFuture;
  int? _currentUserId;
  bool _isOwner(LostPetAdDto ad) => _currentUserId != null && ad.userId == _currentUserId;

  @override
  void initState() {
    super.initState();
    _adFuture = fetchLostPetAd(widget.adId);
    _loadCurrentUserId();
    InterstitialAdManager.instance.registerClick();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadCurrentUserId() async {
    final user = await SessionManager().getUser();
    setState(() {
      _currentUserId = user != null ? user['id'] as int? : null;
    });
  }

  Future<LostPetAdDto> fetchLostPetAd(int id) async {
    final ad = await LostPetAdApiService().getById(id);
    if (ad == null) throw Exception('Lost pet ad not found');
    return ad;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: BaseAppBar(
        title: 'lost_pets.detail_title'.tr(),
        showLogo: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Geri',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            tooltip: 'Dili Değiştir',
            onPressed: () {
              final current = context.locale;
              final newLocale = current.languageCode == 'tr' ? const Locale('en') : const Locale('tr');
              context.setLocale(newLocale);
            },
            color: isDark ? AppColors.darkPrimary : AppColors.petsolivePrimary,
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? AppColors.darkPrimary : AppColors.petsolivePrimary,
            ),
            tooltip: isDark ? 'Aydınlık Tema' : 'Karanlık Tema',
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: FutureBuilder<LostPetAdDto>(
        future: _adFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('lost_pets.error'.tr()));
          }
          final ad = snapshot.data!;
          _userFuture ??= UserApiService().getById(ad.userId);
          final isOwner = _isOwner(ad);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- PET GÖRSELİ ve BAŞLIK ---
                  GestureDetector(
                    onTap: () {
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.85),
                        builder: (ctx) => Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: const EdgeInsets.all(12),
                          child: Hero(
                            tag: 'lost_pet_image_${ad.id}',
                            child: InteractiveViewer(
                              minScale: 0.8,
                              maxScale: 4.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: ad.imageUrl.isNotEmpty
                                    ? Image.network(
                                        ad.imageUrl,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.pets, size: 120),
                                        ),
                                      )
                                    : Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.pets, size: 120),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: ad.imageUrl.isNotEmpty
                              ? Image.network(
                                  ad.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 240,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[300],
                                    height: 240,
                                    child: const Icon(Icons.pets, size: 80),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  height: 240,
                                  child: const Icon(Icons.pets, size: 80),
                                ),
                        ),
                        // Gradient ve başlık
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(0.65)],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 18,
                          bottom: 18,
                          child: Row(
                            children: [
                              Icon(Icons.pets, color: Colors.white, size: 28),
                              const SizedBox(width: 10),
                              Text(
                                ad.petName,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: Colors.white,
                                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Büyütme/fullscreen ikonu
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.all(7),
                            child: const Icon(Icons.fullscreen, color: Colors.white, size: 26),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // --- AÇIKLAMA BÖLÜMÜ ---
                  Text('lost_pet_ad.description'.tr(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.blueGrey[900] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(ad.description, style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16)),
                  ),
                  const SizedBox(height: 24),
                  // --- KONUM & TARİHLER ---
                  Text('lost_pet_ad.details'.tr(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _iconInfoRow(Icons.location_on, 'lost_pet_ad.location'.tr(), (ad.lastSeenLocation.isNotEmpty ? ad.lastSeenLocation : '${ad.lastSeenCity}, ${ad.lastSeenDistrict}').replaceAll('[', '').replaceAll(']', ''), theme),
                  const SizedBox(height: 8),
                  _iconInfoRow(Icons.calendar_today, 'lost_pet_ad.last_seen_date'.tr(), DateFormat('dd.MM.yyyy').format(ad.lastSeenDate), theme),
                  const SizedBox(height: 8),
                  _iconInfoRow(Icons.calendar_today, 'lost_pet_ad.created_at'.tr(), DateFormat('dd.MM.yyyy').format(ad.createdAt), theme),
                  const SizedBox(height: 32),
                  // --- KULLANICI BİLGİLERİ BAŞLIK ve AYRAÇ ---
                  Row(
                    children: [
                      Expanded(child: Divider(thickness: 1.2)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: theme.colorScheme.primary, size: 26),
                            const SizedBox(width: 8),
                            Text('lost_pet_ad.owner_title'.tr(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(child: Divider(thickness: 1.2)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // --- KULLANICI BİLGİLERİ ---
                  FutureBuilder<UserDto?> (
                    future: _userFuture,
                    builder: (context, userSnap) {
                      if (userSnap.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (userSnap.hasError || userSnap.data == null) {
                        return Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red[700], size: 22),
                            const SizedBox(width: 8),
                            Expanded(child: Text('lost_pet_ad.owner_error'.tr(), style: theme.textTheme.bodyMedium)),
                          ],
                        );
                      }
                      final user = userSnap.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                                  ? _ProfileAvatarWithFallback(imageUrl: user.profileImageUrl!, username: user.username)
                                  : CircleAvatar(
                                      radius: 28,
                                      backgroundColor: _avatarColor(user.username),
                                      child: Text(
                                        user.username.isNotEmpty ? user.username[0].toUpperCase() : '',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            user.username,
                                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (user.isActive == true)
                                          Icon(Icons.verified, color: theme.colorScheme.primary, size: 20, semanticLabel: 'lost_pet_ad.verified'.tr()),
                                      ],
                                    ),
                                    if (user.roles != null && user.roles!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          'lost_pet_ad.roles'.tr() + ': ' + user.roles!.join(', '),
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13.5,
                                            letterSpacing: 0.1,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Diğer bilgiler blok halinde
                          _iconInfoRow(Icons.email, 'lost_pet_ad.email'.tr(), user.email, theme),
                          if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            _iconInfoRow(Icons.phone, 'lost_pet_ad.phone'.tr(), user.phoneNumber!, theme),
                          ],
                          if (user.address != null && user.address!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            _iconInfoRow(Icons.home, 'lost_pet_ad.address'.tr(), user.address!, theme),
                          ],
                          if (user.city != null && user.city!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            _iconInfoRow(Icons.location_city, 'lost_pet_ad.city'.tr(), user.city!, theme),
                          ],
                          if (user.district != null && user.district!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            _iconInfoRow(Icons.map, 'lost_pet_ad.district'.tr(), user.district!, theme),
                          ],
                          // BUTONLAR: sadece ilan sahibi ise
                          if (isOwner) ...[
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.edit),
                                    label: Text('lost_pet_ad.form_edit'.tr()),
                                    onPressed: () async {
                                      if (!mounted) return;
                                      final result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => EditLostPetAdScreen(ad: ad),
                                        ),
                                      );
                                      if (!mounted) return;
                                      if (result == true) {
                                        // Düzenleme sonrası ilanı tekrar yükle
                                        setState(() {
                                          _adFuture = fetchLostPetAd(widget.adId);
                                          _userFuture = null;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.delete),
                                    label: Text('lost_pet_ad.form_delete'.tr()),
                                    onPressed: () async {
                                      if (!mounted) return;
                                      final confirmed = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => DeleteConfirmationScreen(
                                            title: 'delete_confirm.title'.tr(),
                                            description: 'delete_confirm.description'.tr(),
                                            confirmText: 'delete_confirm.confirm'.tr(),
                                            cancelText: 'form.cancel'.tr(),
                                            onConfirm: () {
                                              Navigator.of(ctx).pop(true);
                                            },
                                          ),
                                        ),
                                      );
                                      if (!mounted) return;
                                      if (confirmed == true) {
                                        try {
                                          final sessionManager = SessionManager();
                                          final token = await sessionManager.getToken() ?? '';
                                          await context.read<LostPetAdCubit>().delete(ad.id, token);
                                          // Silme sonrası listeyi güncelle
                                          context.read<LostPetAdCubit>().getAll();
                                          if (!mounted) return;
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('İlan başarıyla silindi.'), backgroundColor: Colors.green),
                                          );
                                        } catch (e) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Silme işlemi başarısız: $e'), backgroundColor: Colors.red),
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                      foregroundColor: Theme.of(context).colorScheme.onError,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 18),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  AdmobBannerWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _iconInfoRow(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 22),
        const SizedBox(width: 10),
        Text('$label: ', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
      ],
    );
  }

  // Google tarzı baş harfe göre renkli avatar rengi
  Color _avatarColor(String name) {
    if (name.isEmpty) return Colors.blue;
    final code = name.codeUnitAt(0);
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.brown,
      Colors.cyan,
    ];
    return colors[code % colors.length].shade400;
  }
}

class _ProfileAvatarWithFallback extends StatelessWidget {
  final String imageUrl;
  final String username;
  const _ProfileAvatarWithFallback({required this.imageUrl, required this.username});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.13),
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (_, __) {},
      child: _NetworkImageWithFallback(imageUrl: imageUrl, username: username),
    );
  }
}

class _NetworkImageWithFallback extends StatelessWidget {
  final String imageUrl;
  final String username;
  const _NetworkImageWithFallback({required this.imageUrl, required this.username});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
        );
      },
    );
  }
} 