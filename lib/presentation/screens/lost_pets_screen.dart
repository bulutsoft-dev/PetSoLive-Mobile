import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/lost_pet_ad_cubit.dart';
import '../../data/models/lost_pet_ad_dto.dart';
import '../../injection_container.dart';
import 'package:intl/intl.dart';
import 'lost_pet_ad_screen.dart';
import '../../data/providers/user_api_service.dart';
import '../widgets/lost_pet_ad_card.dart';
import '../localization/locale_keys.g.dart';
import 'add_lost_pet_ad_screen.dart';
import '../../core/network/auth_service.dart';

class LostPetsScreen extends StatefulWidget {
  const LostPetsScreen({Key? key}) : super(key: key);

  @override
  State<LostPetsScreen> createState() => _LostPetsScreenState();
}

class _LostPetsScreenState extends State<LostPetsScreen> {
  String searchQuery = '';
  String selectedCity = '';
  String selectedDistrict = '';
  final TextEditingController _searchController = TextEditingController();
  bool myAdsOnly = false;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final authService = AuthService();
    final user = await authService.getUser();
    setState(() {
      currentUserId = user != null ? user['id'] as int? : null;
    });
  }

  Locale? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = context.locale;
    if (_lastLocale != currentLocale) {
      _lastLocale = currentLocale;
      setState(() {}); // Dil değiştiyse rebuild
    }
  }

  List<String> getCities(List<LostPetAdDto> ads) =>
      ads.map((e) => e.lastSeenCity).where((c) => c.isNotEmpty).toSet().toList();
  List<String> getDistricts(List<LostPetAdDto> ads, String city) =>
      ads.where((e) => e.lastSeenCity == city).map((e) => e.lastSeenDistrict).where((d) => d.isNotEmpty).toSet().toList();

  List<LostPetAdDto> filterAds(List<LostPetAdDto> ads) {
    return ads.where((ad) {
      final matchesQuery = searchQuery.isEmpty ||
          (ad.petName.toLowerCase().contains(searchQuery.toLowerCase())) ||
          (ad.description.toLowerCase().contains(searchQuery.toLowerCase()));
      final matchesCity = selectedCity.isEmpty || (ad.lastSeenCity == selectedCity);
      final matchesDistrict = selectedDistrict.isEmpty || (ad.lastSeenDistrict == selectedDistrict);
      final matchesOwner = !myAdsOnly || (currentUserId != null && ad.userId == currentUserId);
      return matchesQuery && matchesCity && matchesDistrict && matchesOwner;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'lostPetsFab',
        onPressed: () async {
          final authService = AuthService();
          final token = await authService.getToken();
          final user = await authService.getUser();
          if (token == null || user == null) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kayıt eklemek için giriş yapmalısınız.')),
              );
              await Future.delayed(const Duration(seconds: 1));
              Navigator.of(context).pushReplacementNamed('/login');
            }
            return;
          }
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddLostPetAdScreen(),
            ),
          );
          if (result == true) {
            context.read<LostPetAdCubit>().getAll();
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Kayıp İlanı Ekle',
      ),
      body: BlocBuilder<LostPetAdCubit, LostPetAdState>(
        builder: (context, state) {
              if (state is LostPetAdLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LostPetAdError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text('lost_pets.error'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red)),
                      const SizedBox(height: 8),
                      Text(state.error, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                    ],
                  ),
                );
              } else if (state is LostPetAdLoaded) {
                final allAds = state.ads;
                final cities = getCities(allAds);
                final districts = selectedCity.isNotEmpty ? getDistricts(allAds, selectedCity) : <String>[];
                final filteredAds = filterAds(allAds);
                final userHasAds = currentUserId != null && allAds.any((ad) => ad.userId == currentUserId);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Şehir filtresi
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedCity,
                              isExpanded: true,
                              decoration: InputDecoration(labelText: 'lost_pets_city'.tr()),
                              items: [DropdownMenuItem(value: '', child: Text('lost_pets_all'.tr()))] +
                                  cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                              onChanged: (v) => setState(() {
                                selectedCity = v ?? '';
                                selectedDistrict = '';
                              }),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // İlçe filtresi
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedDistrict,
                              isExpanded: true,
                              decoration: InputDecoration(labelText: 'lost_pets_district'.tr()),
                              items: [DropdownMenuItem(value: '', child: Text('lost_pets_all'.tr()))] +
                                  districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                              onChanged: (v) => setState(() => selectedDistrict = v ?? ''),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'lost_pets_search_hint'.tr(),
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => setState(() => searchQuery = v),
                      ),
                    ),
                    if (userHasAds)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 4),
                        child: Center(
                          child: FilterChip(
                            label: Text(
                              'lost_pets.my_ads_only'.tr(),
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            avatar: const Icon(Icons.person, size: 18),
                            selected: myAdsOnly,
                            selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                            checkmarkColor: Theme.of(context).colorScheme.primary,
                            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                            shape: StadiumBorder(side: BorderSide(color: Theme.of(context).colorScheme.primary)),
                            onSelected: (v) => setState(() => myAdsOnly = v),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (filteredAds.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, color: Theme.of(context).colorScheme.primary, size: 48),
                              const SizedBox(height: 12),
                              Text('lost_pets.empty'.tr(), style: Theme.of(context).textTheme.titleLarge),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          itemCount: filteredAds.length,
                          itemBuilder: (context, index) {
                            final ad = filteredAds[index];
                            return LostPetAdCard(
                              ad: ad,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LostPetAdScreen(adId: ad.id),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
      );
  }
}

extension StringCasingExtension on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
} 