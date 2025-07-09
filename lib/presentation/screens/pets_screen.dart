import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/pet_cubit.dart';
import '../widgets/pet_card.dart';
import 'pet_detail_screen.dart';
import 'add_pet_screen.dart';
import '../../injection_container.dart';
import '../../domain/repositories/adoption_repository.dart';
import '../blocs/account_cubit.dart';
import '../../data/providers/pet_owner_api_service.dart';

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
  String searchQuery = '';
  final TextEditingController _controller = TextEditingController();
  Map<int, bool> adoptedStatus = {};
  Map<int, String?> adoptedOwner = {};
  bool adoptionLoading = false;
  List petsCache = [];
  int? currentUserId;

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
      // Her zaman allPets üzerinden fetchAdoptionStatuses çağır
      final pets = state is PetLoaded ? state.allPets : (state as PetFiltered).pets;
      if (petsCache != pets) {
        petsCache = pets;
        fetchAdoptionStatuses(pets);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final accountState = context.read<AccountCubit>().state;
    if (accountState is AccountSuccess) {
      currentUserId = accountState.response.user.id;
    }
  }

  List filterPets(List pets) {
    // Sıralama: Sahiplendirilmemişler en üstte, sahiplendirilmişler en altta, yeni eklenenler en üstte (id'ye göre)
    final sorted = List.from(pets);
    sorted.sort((a, b) {
      final aAdopted = adoptedStatus[a.id] ?? false;
      final bAdopted = adoptedStatus[b.id] ?? false;
      if (aAdopted != bAdopted) {
        // Sahiplendirilmemişler önce gelsin
        return aAdopted ? 1 : -1;
      }
      // id'ye göre yeni eklenenler en üstte
      return b.id.compareTo(a.id); // id büyük olan önce
    });
    return sorted.where((pet) {
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
    return BlocProvider(
      create: (_) => PetCubit(sl())
        ..getAllWithOwners(
          userId: currentUserId,
          petOwnerApiService: sl<PetOwnerApiService>(),
                ),
      child: BlocBuilder<PetCubit, PetState>(
        builder: (context, state) {
          if (state is PetLoaded) {
            final showMyPetsTab = currentUserId != null && state.myPets.isNotEmpty;
            final tabs = <Tab>[
              Tab(text: 'pets.tab_all'.tr(context: context)),
              Tab(text: 'pets.tab_owned'.tr(context: context)),
              Tab(text: 'pets.tab_waiting'.tr(context: context)),
              if (showMyPetsTab) Tab(text: 'pets.tab_my_pets'.tr(context: context)),
            ];
            final tabViews = <Widget>[
              // All Pets
              _PetListView(
                filter: (pet) => true,
                adoptedStatus: adoptedStatus,
                adoptedOwner: adoptedOwner,
                adoptionLoading: adoptionLoading,
                filterPets: filterPets,
                petsCache: state.allPets,
                currentUserId: currentUserId,
              ),
              // Owned (adopted)
              _PetListView(
                filter: (pet) => adoptedStatus[pet.id] == true,
                adoptedStatus: adoptedStatus,
                adoptedOwner: adoptedOwner,
                adoptionLoading: adoptionLoading,
                filterPets: filterPets,
                petsCache: state.allPets,
                currentUserId: currentUserId,
              ),
              // Waiting (not adopted)
              _PetListView(
                filter: (pet) => adoptedStatus[pet.id] == false,
                adoptedStatus: adoptedStatus,
                adoptedOwner: adoptedOwner,
                adoptionLoading: adoptionLoading,
                filterPets: filterPets,
                petsCache: state.allPets,
                currentUserId: currentUserId,
              ),
              if (showMyPetsTab)
                _PetListView(
                  filter: (pet) => pet.ownerId == currentUserId,
                  adoptedStatus: adoptedStatus,
                  adoptedOwner: adoptedOwner,
                  adoptionLoading: adoptionLoading,
                  filterPets: filterPets,
                  petsCache: state.myPets,
                  currentUserId: currentUserId,
                ),
            ];
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onPetStateChanged(state);
            });
            return DefaultTabController(
              key: ValueKey(tabs.length),
              length: tabs.length,
              child: Scaffold(
                body: Column(
                  children: [
                    TabBar(tabs: tabs),
                    Expanded(child: TabBarView(children: tabViews)),
                  ],
                ),
                floatingActionButton: BlocBuilder<AccountCubit, AccountState>(
                  builder: (context, accountState) {
                    final isLoggedIn = accountState is AccountSuccess;
                    final colorScheme = Theme.of(context).colorScheme;
                    return FloatingActionButton(
                      heroTag: 'pets_screen_fab',
                      onPressed: () async {
                        if (isLoggedIn) {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => PetCubit(sl()),
                                child: AddPetScreen(),
                              ),
                            ),
                          );
                          // Kayıt sonrası otomatik reload ve tab güncellemesi
                          if (mounted) {
                            // getAllWithOwners ile myPets güncellenir
                            final accountState = context.read<AccountCubit>().state;
                            int? userId;
                            if (accountState is AccountSuccess) {
                              userId = accountState.response.user.id;
                            }
                            final petCubit = context.read<PetCubit>();
                            final petOwnerApiService = sl<PetOwnerApiService>();
                            await petCubit.getAllWithOwners(
                              userId: userId,
                              petOwnerApiService: petOwnerApiService,
                            );
                            setState(() {});
                          }
                        } else {
                          Navigator.of(context).pushNamed('/login');
                        }
                      },
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.add, size: 28),
                      tooltip: isLoggedIn ? 'pets.add'.tr() : 'Giriş yapmadan ekleyemezsiniz',
                    );
                  },
                ),
              ),
            );
          }
          // ... handle other states ...
          return Center(child: CircularProgressIndicator());
          },
      ),
    );
  }
}

// Pet listesi için ayrı widget
class _PetListView extends StatelessWidget {
  final bool Function(dynamic pet) filter;
  final Map<int, bool> adoptedStatus;
  final Map<int, String?> adoptedOwner;
  final bool adoptionLoading;
  final List petsCache;
  final List Function(List) filterPets;
  final Future<void> Function()? onRefresh;
  final int? currentUserId;

  const _PetListView({
    required this.filter,
    required this.adoptedStatus,
    required this.adoptedOwner,
    required this.adoptionLoading,
    required this.filterPets,
    required this.petsCache,
    this.onRefresh,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: BlocBuilder<PetCubit, PetState>(
        builder: (context, state) {
          if (state is PetLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PetError) {
            return Center(child: Text('pets.error'.tr() + '\n' + state.error));
          } else if (state is PetLoaded || state is PetFiltered) {
            final pets = state is PetLoaded ? state.allPets : (state as PetFiltered).pets;
            if (pets.isEmpty) {
              return ListView(
                children: [
                  SizedBox(height: 200),
                  Center(child: Text('pets.empty'.tr())),
                ],
              );
            }
            if (adoptedStatus.length != pets.length || adoptionLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final filteredPets = filterPets(pets).where(filter).toList();
            if (filteredPets.isEmpty) {
              return ListView(
                children: [
                  SizedBox(height: 200),
                  Center(child: Text('pets.empty'.tr())),
                ],
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: filteredPets.length,
              itemBuilder: (context, index) {
                final pet = filteredPets[index];
                final isAdopted = adoptedStatus[pet.id] ?? false;
                final ownerName = adoptedOwner[pet.id];
                final isMine = currentUserId != null && pet.ownerId == currentUserId;
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
                          petId: pet.id,
                        ),
                      ));
                    },
                    isMine: isMine,
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

// Hayvan sayısı badge'i
class _CountBadge extends StatelessWidget {
  final int count;
  final String label;
  final Color? color;
  const _CountBadge({required this.count, required this.label, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$count $label',
        style: TextStyle(
          color: color != null ? Colors.white : Colors.blueGrey[800],
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
} 