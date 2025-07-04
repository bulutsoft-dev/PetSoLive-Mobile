import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/lost_pet_ad_cubit.dart';
import '../../data/models/lost_pet_ad_dto.dart';
import '../../injection_container.dart';

class LostPetsScreen extends StatelessWidget {
  const LostPetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LostPetAdCubit(sl())..getAll(),
      child: BlocBuilder<LostPetAdCubit, LostPetAdState>(
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
                  Text('lost_pets.error', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red)).tr(),
                  const SizedBox(height: 8),
                  Text(state.error, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                ],
              ),
            );
          } else if (state is LostPetAdLoaded) {
            if (state.ads.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, color: Theme.of(context).colorScheme.primary, size: 48),
                    const SizedBox(height: 12),
                    Text('lost_pets.empty', style: Theme.of(context).textTheme.titleLarge).tr(),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: state.ads.length,
              itemBuilder: (context, index) {
                final ad = state.ads[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {}, // Detay ekranına yönlendirme eklenebilir
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                          child: ad.imageUrl.isNotEmpty
                              ? Image.network(
                                  ad.imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.pets, size: 36, color: Colors.grey),
                                  ),
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.pets, size: 36, color: Colors.grey),
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        ad.petName,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'lost_pets.status_open'.tr(),
                                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  ad.description.length > 60 ? ad.description.substring(0, 60) + '...' : ad.description,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16, color: Theme.of(context).colorScheme.primary),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        ad.lastSeenLocation,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 