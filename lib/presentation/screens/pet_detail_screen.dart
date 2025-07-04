import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/theme_cubit.dart';
import '../themes/colors.dart';
import '../../data/models/pet_dto.dart';
import '../../data/models/pet_owner_dto.dart';
import '../../data/models/adoption_dto.dart';
import '../../data/models/adoption_request_dto.dart';
import '../../data/providers/pet_api_service.dart';
import '../../data/providers/pet_owner_api_service.dart';
import '../../data/providers/adoption_api_service.dart';
import '../widgets/ownership_id_card.dart';
import '../widgets/adoption_request_comment_widget.dart';
import '../blocs/adoption_request_cubit.dart';
import '../../data/repositories/adoption_request_repository_impl.dart';
import '../../data/providers/adoption_request_api_service.dart';

class PetDetailScreen extends StatefulWidget {
  final int petId;
  const PetDetailScreen({Key? key, required this.petId}) : super(key: key);

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  late Future<PetDto> _petFuture;
  late Future<PetOwnerDto?> _ownerFuture;
  late Future<AdoptionDto?> _adoptionFuture;
  late Future<List<AdoptionRequestDto>> _adoptionRequestsFuture;

  // Şimdilik örnek kullanıcı id'si (giriş yapan kullanıcı)
  final int _currentUserId = 1;

  @override
  void initState() {
    super.initState();
    _petFuture = PetApiService().fetchPet(widget.petId);
    _ownerFuture = PetOwnerApiService().fetchPetOwner(widget.petId);
    _adoptionFuture = AdoptionApiService().fetchAdoptionByPetId(widget.petId);
    _adoptionRequestsFuture = AdoptionRequestApiService().getAllByPetId(widget.petId);
  }

  Color? _getColor(String? colorName) {
    if (colorName == null) return null;
    final c = colorName.toLowerCase();
    if (c.contains('siyah') || c.contains('black')) return Colors.black;
    if (c.contains('beyaz') || c.contains('white')) return Colors.white;
    if (c.contains('gri') || c.contains('gray') || c.contains('grey')) return Colors.grey;
    if (c.contains('kahverengi') || c.contains('brown')) return Colors.brown;
    if (c.contains('sarı') || c.contains('yellow')) return Colors.yellow[700];
    if (c.contains('kırmızı') || c.contains('red')) return Colors.red;
    if (c.contains('turuncu') || c.contains('orange')) return Colors.orange;
    if (c.contains('mavi') || c.contains('blue')) return Colors.blue;
    if (c.contains('yeşil') || c.contains('green')) return Colors.green;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: FutureBuilder<PetDto>(
          future: _petFuture,
          builder: (context, petSnap) {
            final petName = petSnap.hasData ? petSnap.data!.name : '';
            return AppBar(
              centerTitle: true,
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.petsoliveBg,
              iconTheme: IconThemeData(
                color: isDark ? AppColors.darkPrimary : AppColors.petsolivePrimary,
              ),
              titleTextStyle: TextStyle(
                color: isDark ? AppColors.darkPrimary : AppColors.petsolivePrimary,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Geri',
              ),
              title: Text(
                petName.isNotEmpty ? petName : 'pet_detail.title'.tr(),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
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
                FutureBuilder<AdoptionDto?>(
                  future: _adoptionFuture,
                  builder: (context, adoptionSnap) {
                    final adoption = adoptionSnap.data;
                    return IconButton(
                      icon: Icon(
                        adoption != null ? Icons.verified : Icons.hourglass_bottom,
                        color: adoption != null ? Colors.green : Colors.amber[800],
                      ),
                      tooltip: adoption != null ? 'pet_detail.status_owned'.tr() : 'pet_detail.status_waiting'.tr(),
                      onPressed: null,
                    );
                  },
                ),
              ],
              elevation: 0,
            );
          },
        ),
      ),
      body: FutureBuilder<PetDto>(
        future: _petFuture,
        builder: (context, petSnap) {
          if (petSnap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!petSnap.hasData) {
            return Center(child: Text('pet_detail.not_found'.tr()));
          }
          final pet = petSnap.data!;
          return FutureBuilder<PetOwnerDto?>(
            future: _ownerFuture,
            builder: (context, ownerSnap) {
              if (ownerSnap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (ownerSnap.hasError) {
                debugPrint('Owner fetch error: \\${ownerSnap.error}');
                return Center(child: Text('pet_detail.owner_error'.tr()));
              }
              debugPrint('Owner fetch result: \\${ownerSnap.data}');
              return FutureBuilder<AdoptionDto?>(
                future: _adoptionFuture,
                builder: (context, adoptionSnap) {
                  if (adoptionSnap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (adoptionSnap.hasError) {
                    debugPrint('Adoption fetch error: \\${adoptionSnap.error}');
                    return Center(child: Text('pet_detail.adoption_error'.tr()));
                  }
                  debugPrint('Adoption fetch result: \\${adoptionSnap.data}');
                  final owner = ownerSnap.data;
                  final adoption = adoptionSnap.data;
                  return ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Card(
                        elevation: 6,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        color: isDark ? colorScheme.surfaceVariant : colorScheme.surface,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Büyük görsel ve badge overlay
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: InteractiveViewer(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(24),
                                            child: Image.network(
                                              pet.imageUrl,
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, __, ___) => Container(
                                                height: 320,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.pets, size: 80),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                                    child: Image.network(
                                      pet.imageUrl,
                                      height: 240,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        height: 240,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.pets, size: 80),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: adoption != null
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: adoption.status.toLowerCase() == 'approved'
                                                ? Colors.green[100]
                                                : adoption.status.toLowerCase() == 'pending'
                                                    ? Colors.amber[100]
                                                    : Colors.red[100],
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: adoption.status.toLowerCase() == 'approved'
                                                  ? Colors.green
                                                  : adoption.status.toLowerCase() == 'pending'
                                                      ? Colors.amber
                                                      : Colors.red,
                                              width: 1.2,
                                            ),
                                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                adoption.status.toLowerCase() == 'approved'
                                                    ? Icons.verified
                                                    : adoption.status.toLowerCase() == 'pending'
                                                        ? Icons.hourglass_bottom
                                                        : Icons.cancel,
                                                color: adoption.status.toLowerCase() == 'approved'
                                                    ? Colors.green
                                                    : adoption.status.toLowerCase() == 'pending'
                                                        ? Colors.amber[800]
                                                        : Colors.red,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                adoption.status.toLowerCase() == 'approved'
                                                    ? 'pet_detail.status_owned'.tr()
                                                    : adoption.status.toLowerCase() == 'pending'
                                                        ? 'pet_detail.status_pending'.tr()
                                                        : 'pet_detail.status_rejected'.tr(),
                                                style: TextStyle(
                                                  color: adoption.status.toLowerCase() == 'approved'
                                                      ? Colors.green[800]
                                                      : adoption.status.toLowerCase() == 'pending'
                                                          ? Colors.amber[900]
                                                          : Colors.red[800],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Adı ve sahip
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          pet.name,
                                          style: theme.textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? AppColors.darkOnBackground
                                                : AppColors.onBackground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  // Kimlik Bilgileri
                                  _GroupTitle(icon: Icons.badge, color: Colors.indigo, text: 'Kimlik Bilgileri'),
                                  const SizedBox(height: 8),
                                  _PetDetailRow(emoji: '🐾', label: 'pet_detail.species'.tr(), value: pet.species),
                                  _PetDetailRow(emoji: '🧬', label: 'pet_detail.breed'.tr(), value: pet.breed),
                                  _PetDetailRow(emoji: '🔗', label: 'pet_detail.microchip_id'.tr(), value: pet.microchipId ?? '-'),
                                  const SizedBox(height: 16),
                                  // Fiziksel Özellikler
                                  _GroupTitle(icon: Icons.pets, color: Colors.teal, text: 'Fiziksel Özellikler'),
                                  const SizedBox(height: 8),
                                  _PetDetailRow(emoji: '🎂', label: 'pet_detail.age'.tr(), value: pet.age != null ? pet.age.toString() : '-'),
                                  _PetDetailRow(emoji: pet.gender != null && pet.gender!.toLowerCase().contains('d') || (pet.gender != null && pet.gender!.toLowerCase().contains('f')) ? '♀️' : '♂️', label: 'pet_detail.gender'.tr(), value: pet.gender ?? '-'),
                                  _PetDetailRow(emoji: '⚖️', label: 'pet_detail.weight'.tr(), value: pet.weight != null ? '${pet.weight!.toStringAsFixed(1)} kg' : '-'),
                                  _PetDetailRow(emoji: '🎨', label: 'pet_detail.color'.tr(), value: pet.color ?? '-'),
                                  _PetDetailRow(emoji: '📅', label: 'pet_detail.date_of_birth'.tr(), value: pet.dateOfBirth != null ? DateFormat('dd.MM.yyyy').format(pet.dateOfBirth!) : '-'),
                                  const SizedBox(height: 16),
                                  // Sağlık Bilgileri
                                  _GroupTitle(icon: Icons.health_and_safety, color: Colors.redAccent, text: 'Sağlık Bilgileri'),
                                  const SizedBox(height: 8),
                                  _PetDetailRow(emoji: '💉', label: 'pet_detail.vaccination_status'.tr(), value: pet.vaccinationStatus ?? '-'),
                                  _PetDetailRow(emoji: '✂️', label: 'pet_detail.is_neutered'.tr(), value: pet.isNeutered != null ? (pet.isNeutered! ? 'pet_detail.yes'.tr() : 'pet_detail.no'.tr()) : '-'),
                                  const SizedBox(height: 16),
                                  // Açıklama
                                  _GroupTitle(icon: Icons.info_outline, color: Colors.blue, text: 'pet_detail.description'.tr()),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.blueGrey[900] : Colors.blue[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(pet.description, style: theme.textTheme.bodyLarge),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      // Sahiplik/adoption bilgileri ayrı kartta
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (adoption != null)
                              OwnershipIdCard(
                                icon: Icons.person,
                                color: Colors.lightBlueAccent,
                                title: 'pet_detail.adopted_by_info'.tr(),
                                username: owner?.userName ?? '-',
                                dateLabel: 'ownership_card.adoption_date'.tr(),
                                date: owner?.ownershipDate == null ? '-' : DateFormat('dd.MM.yyyy').format(adoption.adoptionDate!),
                                explanation: 'ownership_card.adopted_explanation'.tr(),
                                explanationColor: Colors.green[800],
                              )
                            else
                              OwnershipIdCard(
                                icon: Icons.person,
                                color: Colors.lightBlueAccent,
                                title: 'pet_detail.owner_info_waiting'.tr(),
                                username: owner?.userName ?? '-',
                                dateLabel: 'ownership_card.ownership_date'.tr(),
                                date: owner?.ownershipDate == null ? '-' : DateFormat('dd.MM.yyyy').format(owner!.ownershipDate!),
                                explanation: 'ownership_card.waiting_explanation'.tr(),
                                explanationColor: Colors.amber[500],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Card(
                        color: isDark ? Colors.grey[900] : Colors.grey[100],
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.assignment_turned_in, size: 20),
                                  const SizedBox(width: 8),
                                  Text('pet_detail.adoption_requests_title'.tr(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('pet_detail.adoption_requests_desc'.tr(), style: theme.textTheme.bodyMedium),
                              const SizedBox(height: 8),
                              BlocProvider(
                                create: (_) => AdoptionRequestCubit(
                                  AdoptionRequestRepositoryImpl(AdoptionRequestApiService()),
                                )..getById(widget.petId),
                                child: BlocBuilder<AdoptionRequestCubit, AdoptionRequestState>(
                                  builder: (context, state) {
                                    if (state is AdoptionRequestLoading) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (state is AdoptionRequestLoaded) {
                                      if (state.request == null) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.info_outline, color: Colors.grey, size: 40),
                                            const SizedBox(height: 8),
                                            Text('pet_detail.no_adoption_request'.tr(), style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                                          ],
                                        );
                                      }
                                      return AdoptionRequestCommentWidget(request: state.request!);
                                    } else if (state is AdoptionRequestError) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.error_outline, color: Colors.red, size: 40),
                                          const SizedBox(height: 8),
                                          Text('pet_detail.adoption_request_error'.tr(args: [state.error]), style: theme.textTheme.bodySmall?.copyWith(color: Colors.red)),
                                          const SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () => context.read<AdoptionRequestCubit>().getById(widget.petId),
                                            child: Text('common.retry'.tr()),
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // AdoptionRequest'ları listele
                      FutureBuilder<List<AdoptionRequestDto>>(
                        future: _adoptionRequestsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text('Başvurular yüklenirken hata oluştu.');
                          }
                          final requests = snapshot.data ?? [];
                          if (requests.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('Bu pet için henüz sahiplenme başvurusu yok.', style: TextStyle(color: Colors.grey)),
                            );
                          }
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(top: 24),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue[100],
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                  child: Text(
                                    'Sahiplenme Başvuruları',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ...requests.map((req) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: req.status?.toLowerCase() == 'approved'
                                          ? Colors.green
                                          : req.status?.toLowerCase() == 'pending'
                                              ? Colors.amber
                                              : Colors.red,
                                      width: 1.1,
                                    ),
                                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person, color: Colors.blue[700]),
                                          const SizedBox(width: 8),
                                          Text(req.userName ?? '-', style: TextStyle(fontWeight: FontWeight.bold)),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: req.status?.toLowerCase() == 'approved'
                                                  ? Colors.green[100]
                                                  : req.status?.toLowerCase() == 'pending'
                                                      ? Colors.amber[100]
                                                      : Colors.red[100],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              req.status?.toLowerCase() == 'approved'
                                                  ? 'Kabul Edildi'
                                                  : req.status?.toLowerCase() == 'pending'
                                                      ? 'Beklemede'
                                                      : 'Reddedildi',
                                              style: TextStyle(
                                                color: req.status?.toLowerCase() == 'approved'
                                                    ? Colors.green[800]
                                                    : req.status?.toLowerCase() == 'pending'
                                                        ? Colors.amber[900]
                                                        : Colors.red[800],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(req.message ?? '-', style: TextStyle(color: Colors.black87)),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                          const SizedBox(width: 4),
                                          Text(
                                            req.requestDate != null
                                                ? DateFormat('dd.MM.yyyy').format(req.requestDate!)
                                                : '-',
                                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          );
                        },
                      ),
                      // Sahiplen butonu sadece giriş yapan kullanıcı sahibi değilse ve başvuru yapmadıysa göster
                      FutureBuilder<PetOwnerDto?>(
                        future: _ownerFuture,
                        builder: (context, ownerSnap) {
                          final owner = ownerSnap.data;
                          return FutureBuilder<List<AdoptionRequestDto>>(
                            future: _adoptionRequestsFuture,
                            builder: (context, reqSnap) {
                              final requests = reqSnap.data ?? [];
                              final isOwner = owner?.userId == _currentUserId;
                              final hasRequest = requests.any((r) => r.userId == _currentUserId);
                              if (isOwner) {
                                return Text('Bu petin sahibisiniz.');
                              }
                              if (hasRequest) {
                                return Text('Daha önce bu pet için başvuru yaptınız.');
                              }
                              return ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.favorite_border),
                                label: Text('pet_detail.adopt').tr(),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _PetDetailRow extends StatelessWidget {
  final String? emoji;
  final String label;
  final String value;
  final Color? valueColor;
  const _PetDetailRow({this.emoji, required this.label, required this.value, this.valueColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (emoji != null) Text(emoji!, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: valueColor != null ? FontWeight.w600 : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Grup başlığı widget'ı
class _GroupTitle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final bool badge;
  const _GroupTitle({required this.icon, required this.color, required this.text, this.badge = false});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
} 