import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:petsolive/presentation/themes/colors.dart';
import '../../data/models/lost_pet_ad_dto.dart';
import '../partials/base_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/theme_cubit.dart';
import 'package:petsolive/data/providers/lost_pet_ad_api_service.dart';

class LostPetAdScreen extends StatefulWidget {
  final int adId;
  const LostPetAdScreen({Key? key, required this.adId}) : super(key: key);

  @override
  State<LostPetAdScreen> createState() => _LostPetAdScreenState();
}

class _LostPetAdScreenState extends State<LostPetAdScreen> {
  late Future<LostPetAdDto> _adFuture;

  @override
  void initState() {
    super.initState();
    _adFuture = fetchLostPetAd(widget.adId);
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BaseAppBar(
          title: 'lost_pets.detail_title'.tr(),
          centerTitle: true,
          showLogo: false,
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.petsoliveBg,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Geri',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.translate),
              tooltip: 'Dili Değiştir',
              onPressed: () async {
                final current = context.locale;
                final newLocale = current.languageCode == 'tr' ? const Locale('en') : const Locale('tr');
                await context.setLocale(newLocale);
                setState(() {});
              },
              color: isDark ? AppColors.darkPrimary : Colors.black,
            ),
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? AppColors.darkPrimary  : Colors.black,
              ),
              tooltip: isDark ? 'Aydınlık Tema' : 'Karanlık Tema',
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
          ],
        ),
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
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Görsel
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: ad.imageUrl.isNotEmpty
                          ? Image.network(
                              ad.imageUrl,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 220,
                                color: Colors.grey[300],
                                child: const Icon(Icons.pets, size: 60),
                              ),
                            )
                          : Container(
                              height: 220,
                              color: Colors.grey[300],
                              child: const Icon(Icons.pets, size: 60),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow(Icons.pets, 'Hayvan Adı', ad.petName),
                          const SizedBox(height: 10),
                          _infoRow(Icons.description, 'Açıklama', ad.description),
                          const SizedBox(height: 10),
                          _infoRow(Icons.location_on, 'Konum', ad.lastSeenLocation.isNotEmpty ? ad.lastSeenLocation : '${ad.lastSeenCity}, ${ad.lastSeenDistrict}'),
                          const SizedBox(height: 10),
                          _infoRow(Icons.calendar_today, 'Son Görülme Tarihi', DateFormat('dd.MM.yyyy').format(ad.lastSeenDate)),
                          const SizedBox(height: 10),
                          _infoRow(Icons.calendar_today, 'İlan Tarihi', DateFormat('dd.MM.yyyy').format(ad.createdAt)),
                          const SizedBox(height: 10),
                          _infoRow(Icons.person, 'İlan Sahibi', ad.userName ?? '-'),
                          const SizedBox(height: 10),
                          _infoRow(Icons.badge, 'Kullanıcı ID', ad.userId.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text('$label: ', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
} 