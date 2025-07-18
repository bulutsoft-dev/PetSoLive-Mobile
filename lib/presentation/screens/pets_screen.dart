import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/pet_cubit.dart';
import '../widgets/pet_card.dart';
import '../../injection_container.dart';
import '../../data/models/pet_list_item.dart';
import '../../data/providers/pet_api_service.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PetsScreenBody();
  }
}

class _PetsScreenBody extends StatefulWidget {
  @override
  State<_PetsScreenBody> createState() => _PetsScreenBodyState();
}

class _PetsScreenBodyState extends State<_PetsScreenBody> {
  String? speciesFilter;
  String? colorFilter;
  String? breedFilter;
  String? adoptedStatusFilter;
  String searchQuery = '';
  int? currentUserId;
  final TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Kullanıcı id'sini al
    // (Gerekirse AccountCubit ile entegre et)
  }

  void _openFilterModal(BuildContext context) async {
    String? tempSpecies = speciesFilter;
    String? tempColor = colorFilter;
    String? tempBreed = breedFilter;
    String? tempAdoptedStatus = adoptedStatusFilter;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16, right: 16, top: 24),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text('Filtrele', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 18),
                    Text('Tür', style: Theme.of(context).textTheme.labelLarge),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'pets.filter_species'.tr(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      controller: TextEditingController(text: tempSpecies),
                      onChanged: (v) => setModalState(() => tempSpecies = v),
                    ),
                    const SizedBox(height: 14),
                    Text('Renk', style: Theme.of(context).textTheme.labelLarge),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'pets.filter_color'.tr(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      controller: TextEditingController(text: tempColor),
                      onChanged: (v) => setModalState(() => tempColor = v),
                    ),
                    const SizedBox(height: 14),
                    Text('Cins', style: Theme.of(context).textTheme.labelLarge),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'pets.filter_breed'.tr(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      controller: TextEditingController(text: tempBreed),
                      onChanged: (v) => setModalState(() => tempBreed = v),
                    ),
                    const SizedBox(height: 14),
                    Text('Sahiplenme Durumu', style: Theme.of(context).textTheme.labelLarge),
                    DropdownButtonFormField<String>(
                      value: tempAdoptedStatus,
                      isDense: true,
                      decoration: InputDecoration(
                        hintText: 'Tümü',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      items: [null, 'owned', 'waiting'].map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s == null ? 'Tümü' : s == 'owned' ? 'Sahiplenilmiş' : 'Sahiplenilmeyi Bekleyen'),
                      )).toList(),
                      onChanged: (v) => setModalState(() => tempAdoptedStatus = v),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              speciesFilter = null;
                              colorFilter = null;
                              breedFilter = null;
                              adoptedStatusFilter = null;
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Temizle'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              speciesFilter = tempSpecies;
                              colorFilter = tempColor;
                              breedFilter = tempBreed;
                              adoptedStatusFilter = tempAdoptedStatus;
                            });
                            context.read<PetCubit>().fetchPets(
                              reset: true,
                              species: speciesFilter,
                              color: colorFilter,
                              breed: breedFilter,
                              adoptedStatus: adoptedStatusFilter,
                              search: searchQuery,
                              ownerId: currentUserId,
                            );
                            Navigator.pop(context);
                          },
                          child: Text('Uygula'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PetCubit(sl())
        ..fetchPets(reset: true),
      child: BlocBuilder<PetCubit, PetState>(
        builder: (context, state) {
          if (state is PetLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PetError) {
            return Center(child: Text('pets.error'.tr() + '\n' + state.error));
          } else if (state is PetLoaded) {
            final pets = state.pets;
            if (pets.isEmpty) {
              return Center(child: Text('pets.empty'.tr()));
            }
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && state.hasMore) {
                  context.read<PetCubit>().fetchPets();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<PetCubit>().fetchPets(reset: true,
                    species: speciesFilter,
                    color: colorFilter,
                    breed: breedFilter,
                    adoptedStatus: adoptedStatusFilter,
                    search: searchQuery,
                    ownerId: currentUserId,
                  );
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: pets.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < pets.length) {
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
                          ownerName: pet.adoptedOwnerName,
                          onTap: () async {
                            // Detay ekranına git
                          },
                          isMine: currentUserId != null && pet.ownerId == currentUserId,
                        ),
                      );
                    } else {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ));
                    }
                  },
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
} 