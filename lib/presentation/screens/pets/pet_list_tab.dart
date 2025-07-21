import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/pet_list_item.dart';
import '../../widgets/pet_card.dart';
import '../../screens/pet_detail_screen.dart';
import '../../blocs/pet_cubit.dart';
import 'pet_search_utils.dart';

class PetListTab extends StatelessWidget {
  final String? adoptedStatus;
  final String? species;
  final String? color;
  final String? breed;
  final String? search;
  final bool myPetsOnly;
  final int? currentUserId;
  const PetListTab({this.adoptedStatus, this.species, this.color, this.breed, this.search, this.myPetsOnly = false, this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        if (state is PetLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PetError) {
          return Center(child: Text('pets.error'.tr() + '\n' + state.error));
        } else if (state is PetLoaded) {
          List<PetListItem> pets = filterPets(
            state.pets,
            search,
            species: species,
            color: color,
            breed: breed,
            adoptedStatus: adoptedStatus,
            currentUserId: currentUserId,
            myPetsOnly: myPetsOnly,
          );
          if (pets.isEmpty) {
            return Center(child: Text('pets.empty'.tr()));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: PetCard(
                  name: pet.name,
                  species: pet.species,
                  imageUrl: pet.imageUrl,
                  description: pet.description,
                  age: pet.age,
                  gender: pet.gender,
                  color: pet.color,
                  vaccinationStatus: pet.vaccinationStatus,
                  isAdopted: pet.isAdopted,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PetDetailScreen(petId: pet.id),
                      ),
                    );
                  },
                  isMine: currentUserId != null && pet.ownerId == currentUserId,
                ),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
} 