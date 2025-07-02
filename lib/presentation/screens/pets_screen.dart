import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/pet_cubit.dart';
import '../widgets/pet_card.dart';
import 'pet_detail_screen.dart';
import '../../injection_container.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PetCubit(sl())..getAll(),
      child: BlocBuilder<PetCubit, PetState>(
        builder: (context, state) {
          if (state is PetLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PetError) {
            return Center(child: Text('pets.error'.tr() + '\n' + state.error));
          } else if (state is PetLoaded) {
            if (state.pets.isEmpty) {
              return Center(child: Text('pets.empty'.tr()));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: state.pets.length,
              itemBuilder: (context, index) {
                final pet = state.pets[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: PetCard(
                    name: pet.name,
                    species: pet.species,
                    imageUrl: pet.imageUrl ?? '',
                    description: pet.description ?? '',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PetDetailScreen(
                          name: pet.name,
                          species: pet.species,
                          imageUrl: pet.imageUrl ?? '',
                          description: pet.description ?? '',
                        ),
                      ));
                    },
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