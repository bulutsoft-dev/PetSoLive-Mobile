import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/pet_card.dart';
import '../widgets/help_request_card.dart';
import '../widgets/lost_pet_ad_card.dart';
import 'pet_detail_screen.dart';
import '../blocs/pet_cubit.dart';
import '../blocs/lost_pet_ad_cubit.dart';
import '../blocs/help_request_cubit.dart';
import '../../injection_container.dart';
import '../localization/locale_keys.g.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/admob_constants.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) onTabChange;
  const HomeScreen({Key? key, required this.onTabChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 400 ? screenWidth * 0.95 : 400.0;
    final headerHeight = 180.0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PetCubit(sl())..getAll()),
        BlocProvider(create: (_) => LostPetAdCubit(sl())..getAll()),
        BlocProvider(create: (_) => HelpRequestCubit(sl())..getAll()),
      ],
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 0),
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 110, height: 60, fit: BoxFit.contain),
                  const SizedBox(height: 14),
                  Text(
                    'app_name'.tr(),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      letterSpacing: 0.2,
                      shadows: [Shadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'home.header_subtitle'.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                      shadows: [Shadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // BÖLÜM BAŞLIKLARI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.pets, color: colorScheme.primary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'home.featured_pets'.tr(),
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    tooltip: 'common.see_all'.tr(),
                    onPressed: () {
                      onTabChange(0);
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<PetCubit, PetState>(
              builder: (context, state) {
                if (state is PetLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PetError) {
                  return Center(child: Text('pets.error'.tr() + '\n' + state.error));
                } else if (state is PetLoaded || state is PetFiltered) {
                  final pets = state is PetLoaded ? state.allPets : (state as PetFiltered).pets;
                  if (pets.isEmpty) {
                    return Center(child: Text('pets.empty'.tr()));
                  }
                  final lastPets = pets.length > 3 ? pets.sublist(pets.length - 3) : pets;
                  return Column(
                    children: lastPets.map((pet) => Center(
                      child: SizedBox(
                        width: cardWidth,
                        child: PetCard(
                          name: pet.name,
                          species: pet.species,
                          imageUrl: pet.imageUrl ?? '',
                          description: pet.description ?? '',
                          age: pet.age,
                          gender: pet.gender,
                          color: pet.color,
                          vaccinationStatus: pet.vaccinationStatus,
                          isAdopted: false,
                          ownerName: null,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PetDetailScreen(
                                petId: pet.id,
                              ),
                            ));
                          },
                        ),
                      ),
                    )).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            // Son Eklenen Kayıp İlanları (Dikey Liste)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.search, color: colorScheme.secondary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'home.featured_lost_pets'.tr(),
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    tooltip: 'common.see_all'.tr(),
                    onPressed: () {
                      onTabChange(1);
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<LostPetAdCubit, LostPetAdState>(
              builder: (context, state) {
                if (state is LostPetAdLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LostPetAdError) {
                  return Center(child: Text('lost_pets.error'.tr() + '\n' + state.error));
                } else if (state is LostPetAdLoaded) {
                  final ads = state.ads;
                  if (ads.isEmpty) {
                    return Center(child: Text('lost_pets.empty'.tr()));
                  }
                  final lastAds = ads.length > 3 ? ads.sublist(ads.length - 3) : ads;
                  return Column(
                    children: lastAds.map((ad) => Center(
                      child: SizedBox(
                        width: cardWidth,
                        child: LostPetAdCard(
                          ad: ad,
                          onTap: () {
                            Navigator.of(context).pushNamed('/lost_pet_ad', arguments: ad.id);
                          },
                        ),
                      ),
                    )).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            // Son Yardım Talepleri (Dikey Liste)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.volunteer_activism, color: colorScheme.tertiary ?? colorScheme.primary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'home.featured_help_requests'.tr(),
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    tooltip: 'common.see_all'.tr(),
                    onPressed: () {
                      onTabChange(3);
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<HelpRequestCubit, HelpRequestState>(
              builder: (context, state) {
                if (state is HelpRequestLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HelpRequestError) {
                  return Center(child: Text('help_requests.error'.tr() + '\n' + state.error));
                } else if (state is HelpRequestLoaded) {
                  final requests = state.helpRequests;
                  if (requests.isEmpty) {
                    return Center(child: Text('help_requests.empty'.tr()));
                  }
                  final lastRequests = requests.length > 3 ? requests.sublist(requests.length - 3) : requests;
                  return Column(
                    children: lastRequests.map((req) => Center(
                      child: SizedBox(
                        width: cardWidth,
                        child: HelpRequestCard(
                          request: req,
                          onTap: () {
                            Navigator.of(context).pushNamed('/help_request', arguments: req.id);
                          },
                        ),
                      ),
                    )).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            // Banner Ad
            _HomeBannerAd(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HomeBannerAd extends StatefulWidget {
  @override
  State<_HomeBannerAd> createState() => _HomeBannerAdState();
}

class _HomeBannerAdState extends State<_HomeBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdMobAdUnitIds.bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const SizedBox(height: 0);
    return Center(
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}

class _DelayedAnimatedTile extends StatefulWidget {
  final Widget child;
  final int delay;
  const _DelayedAnimatedTile({required this.child, this.delay = 0});

  @override
  State<_DelayedAnimatedTile> createState() => _DelayedAnimatedTileState();
}

class _DelayedAnimatedTileState extends State<_DelayedAnimatedTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _animation.value) * 40),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _SimpleFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _SimpleFeature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 38),
        const SizedBox(height: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
            fontSize: 15.5,
            letterSpacing: 0.1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.8),
            fontSize: 13.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
