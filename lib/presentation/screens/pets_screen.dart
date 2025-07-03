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

  // Filtreler
  String statusFilter = 'all'; // all, owned, waiting
  String? speciesFilter;
  String? colorFilter;
  String? breedFilter;

  List<String> get speciesList => petsCache.map((p) => p.species as String).toSet().toList();
  List<String> get colorList => petsCache.map((p) => p.color as String).toSet().toList();
  List<String> get breedList => petsCache.map((p) => p.breed as String).toSet().toList();

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

  List filterPets(List pets) {
    return pets.where((pet) {
      final adopted = adoptedStatus[pet.id] ?? false;
      if (statusFilter == 'owned' && !adopted) return false;
      if (statusFilter == 'waiting' && adopted) return false;
      if (speciesFilter != null && speciesFilter!.isNotEmpty && pet.species != speciesFilter) return false;
      if (colorFilter != null && colorFilter!.isNotEmpty && pet.color != colorFilter) return false;
      if (breedFilter != null && breedFilter!.isNotEmpty && pet.breed != breedFilter) return false;
      return true;
    }).toList();
  }

  void _openFilterModal(BuildContext context) async {
    String tempStatus = statusFilter;
    String? tempSpecies = speciesFilter;
    String? tempColor = colorFilter;
    String? tempBreed = breedFilter;
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
                    Text('Durum', style: Theme.of(context).textTheme.labelLarge),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text('pets.filter_all'.tr()),
                          selected: tempStatus == 'all',
                          onSelected: (_) => setModalState(() => tempStatus = 'all'),
                        ),
                        ChoiceChip(
                          label: Text('pets.owned'.tr()),
                          selected: tempStatus == 'owned',
                          onSelected: (_) => setModalState(() => tempStatus = 'owned'),
                        ),
                        ChoiceChip(
                          label: Text('pets.waiting'.tr()),
                          selected: tempStatus == 'waiting',
                          onSelected: (_) => setModalState(() => tempStatus = 'waiting'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text('Tür', style: Theme.of(context).textTheme.labelLarge),
                    DropdownButtonFormField<String>(
                      value: tempSpecies,
                      isDense: true,
                      decoration: InputDecoration(
                        hintText: 'pets.filter_species'.tr(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      items: [null, ...speciesList].map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s ?? 'pets.filter_all'.tr()),
                      )).toList(),
                      onChanged: (v) => setModalState(() => tempSpecies = v),
                    ),
                    const SizedBox(height: 14),
                    Text('Renk', style: Theme.of(context).textTheme.labelLarge),
                    DropdownButtonFormField<String>(
                      value: tempColor,
                      isDense: true,
                      decoration: InputDecoration(
                        hintText: 'pets.filter_color'.tr(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      items: [null, ...colorList].map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c ?? 'pets.filter_all'.tr()),
                      )).toList(),
                      onChanged: (v) => setModalState(() => tempColor = v),
                    ),
                    const SizedBox(height: 14),
                    Text('Cins', style: Theme.of(context).textTheme.labelLarge),
                    DropdownButtonFormField<String>(
                      value: tempBreed,
                      isDense: true,
                      decoration: InputDecoration(
                        hintText: 'pets.filter_breed'.tr(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      items: [null, ...breedList].map((b) => DropdownMenuItem(
                        value: b,
                        child: Text(b ?? 'pets.filter_all'.tr()),
                      )).toList(),
                      onChanged: (v) => setModalState(() => tempBreed = v),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              statusFilter = 'all';
                              speciesFilter = null;
                              colorFilter = null;
                              breedFilter = null;
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Temizle'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              statusFilter = tempStatus;
                              speciesFilter = tempSpecies;
                              colorFilter = tempColor;
                              breedFilter = tempBreed;
                            });
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

  void _clearFilterChip(String type) {
    setState(() {
      if (type == 'status') statusFilter = 'all';
      if (type == 'species') speciesFilter = null;
      if (type == 'color') colorFilter = null;
      if (type == 'breed') breedFilter = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PetCubit, PetState>(
        listener: (context, state) => _onPetStateChanged(state),
        child: Column(
          children: [
            // Sayfa başlığı
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Builder(
                builder: (context) {
                  String title;
                  if (statusFilter == 'waiting') {
                    title = 'pets.title_waiting'.tr();
                  } else if (statusFilter == 'owned') {
                    title = 'pets.title_owned'.tr();
                  } else {
                    title = 'pets.title_all'.tr();
                  }
                  return Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            // Açıklama metni
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
              child: Text(
                'pets.page_description'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
            // Arama çubuğu
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
            // Filtre barı
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 16, 10, 0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.filter_alt),
                    label: Text('Filtrele'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: () => _openFilterModal(context),
                  ),
                  const SizedBox(width: 6),
                  // Seçili filtre chip'leri
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (speciesFilter != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: InputChip(
                                label: Text(speciesFilter!),
                                onDeleted: () => _clearFilterChip('species'),
                              ),
                            ),
                          if (colorFilter != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: InputChip(
                                label: Text(colorFilter!),
                                onDeleted: () => _clearFilterChip('color'),
                              ),
                            ),
                          if (breedFilter != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: InputChip(
                                label: Text(breedFilter!),
                                onDeleted: () => _clearFilterChip('breed'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Hayvan sayısı
                  Builder(
                    builder: (context) {
                      final pets = context.select<PetCubit, List>((cubit) {
                        final state = cubit.state;
                        if (state is PetLoaded) return state.pets;
                        if (state is PetFiltered) return state.pets;
                        return [];
                      });
                      final filteredPets = filterPets(pets);
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '${filteredPets.length} ' + 'pets.count'.tr(),
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey[700]),
                        ),
                      );
                    },
                  ),
                ],
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
                    final filteredPets = filterPets(pets);
                    if (filteredPets.isEmpty) {
                      return Center(child: Text('pets.empty'.tr()));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: filteredPets.length,
                      itemBuilder: (context, index) {
                        final pet = filteredPets[index];
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