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
                return LostPetAdCard(
                  ad: ad,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LostPetAdScreen(ad: ad),
                      ),
                    );
                  },
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