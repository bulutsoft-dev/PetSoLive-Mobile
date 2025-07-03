import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/pet_cubit.dart';
import '../widgets/pet_card.dart';
import 'pet_detail_screen.dart';
import 'add_pet_screen.dart';
import '../../injection_container.dart';
import '../../domain/repositories/adoption_repository.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PetCubit(sl())..getAll(),
      child: _PetsScreenBody(),
    );
  }
}

class _PetsScreenBody extends StatefulWidget {
  @override
  State<_PetsScreenBody> createState() => _PetsScreenBodyState();
}

class _PetsScreenBodyState extends State<_PetsScreenBody> {
  String searchQuery = '';
  final TextEditingController _controller = TextEditingController();
  Map<int, bool> adoptedStatus = {};
  Map<int, String?> adoptedOwner = {};
  bool adoptionLoading = false;
  List petsCache = [];

  Future<void> fetchAdoptionStatuses(List pets) async {
    setState(() { adoptionLoading = true; });
    final adoptionRepo = sl<AdoptionRepository>();
    final Map<int, bool> statusMap = {};
    final Map<int, String?> ownerMap = {};
    final futures = pets.map((pet) async {
      try {
        final adoption = await adoptionRepo.getByPetId(pet.id);
        debugPrint('PetId: \\${pet.id} - Adoption API response: \\${adoption?.toString()}');
        final adopted = adoption != null;
        debugPrint('PetId: \\${pet.id} - Adopted: \\${adopted.toString()}');
        statusMap[pet.id] = adopted;
        ownerMap[pet.id] = adopted ? adoption?.userName : null;
      } catch (e) {
        debugPrint('PetId: \\${pet.id} - Adoption API error: \\${e.toString()}');
        statusMap[pet.id] = false;
        ownerMap[pet.id] = null;
      }
    }).toList();
    await Future.wait(futures);
    if (mounted) {
      setState(() {
        adoptedStatus = statusMap;
        adoptedOwner = ownerMap;
        adoptionLoading = false;
      });
    }
  }

  void _onPetStateChanged(PetState state) {
    if (state is PetLoaded || state is PetFiltered) {
      final pets = state is PetLoaded ? state.pets : (state as PetFiltered).pets;
      if (petsCache != pets) {
        petsCache = pets;
        fetchAdoptionStatuses(pets);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PetCubit, PetState>(
        listener: (context, state) => _onPetStateChanged(state),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'pets.search_hint'.tr(),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) {
                  setState(() => searchQuery = value);
                  context.read<PetCubit>().filterPets(value);
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<PetCubit, PetState>(
                builder: (context, state) {
                  if (state is PetLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PetError) {
                    return Center(child: Text('pets.error'.tr() + '\n' + state.error));
                  } else if (state is PetLoaded || state is PetFiltered) {
                    final pets = state is PetLoaded ? state.pets : (state as PetFiltered).pets;
                    if (pets.isEmpty) {
                      return Center(child: Text('pets.empty'.tr()));
                    }
                    if (adoptedStatus.length != pets.length || adoptionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        final pet = pets[index];
                        final isAdopted = adoptedStatus[pet.id] ?? false;
                        final ownerName = adoptedOwner[pet.id];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: PetCard(
                            name: pet.name,
                            species: pet.species,
                            imageUrl: pet.imageUrl ?? '',
                            description: pet.description ?? '',
                            age: pet.age,
                            gender: pet.gender,
                            color: pet.color,
                            vaccinationStatus: pet.vaccinationStatus,
                            isAdopted: isAdopted,
                            ownerName: ownerName,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => PetDetailScreen(
                                  name: pet.name,
                                  species: pet.species,
                                  imageUrl: pet.imageUrl ?? '',
                                  description: pet.description ?? '',
                                  age: pet.age,
                                  gender: pet.gender,
                                  color: pet.color,
                                  vaccinationStatus: pet.vaccinationStatus,
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'pets_screen_fab',
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AddPetScreen(),
          ));
        },
        child: Icon(Icons.add),
        tooltip: 'pets.add'.tr(),
      ),
    );
  }
}