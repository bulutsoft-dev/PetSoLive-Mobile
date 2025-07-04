import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/lost_pet_ad_dto.dart';

class LostPetAdScreen extends StatelessWidget {
  final LostPetAdDto ad;
  const LostPetAdScreen({Key? key, required this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          iconTheme: IconThemeData(
            color: isDark ? Colors.white : Colors.black,
          ),
          titleTextStyle: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Geri',
          ),
          title: Text(
            'Kayıp Hayvan Detayları',
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
              color: isDark ? Colors.white : Colors.black,
            ),
          ],
          elevation: 0,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
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
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('lost_pets.status_open'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hayvan Adı:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(ad.petName, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      Text('Açıklama:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(ad.description, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 18),
                      Text('Konum:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.colorScheme.primary, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, size: 24, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                (ad.lastSeenLocation.isNotEmpty ? ad.lastSeenLocation : '${ad.lastSeenCity}, ${ad.lastSeenDistrict}'),
                                style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Son Görülme Tarihi:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(DateFormat('dd.MM.yyyy').format(ad.lastSeenDate), style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text('Yayınlanma Tarihi:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(DateFormat('dd.MM.yyyy').format(ad.createdAt), style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 18),
                      Divider(),
                      Text('Sahip Bilgileri', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text('Kullanıcı Adı:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(ad.userName ?? '-', style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 6),
                      Text('Kullanıcı ID:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(ad.userId.toString(), style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 6),
                      Text('Şehir:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(ad.lastSeenCity, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 6),
                      Text('İlçe:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(ad.lastSeenDistrict, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 