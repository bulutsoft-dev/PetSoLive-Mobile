import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/pet_cubit.dart';
import '../widgets/pet_card.dart';
import '../../injection_container.dart';
import '../../data/models/pet_list_item.dart';
import '../../data/providers/pet_api_service.dart';
import 'add_pet_screen.dart';
import 'pet_detail_screen.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PetCubit(sl())..fetchPets(reset: true),
      child: _PetsScreenBody(),
    );
  }
}

class _PetsScreenBody extends StatefulWidget {
  @override
  State<_PetsScreenBody> createState() => _PetsScreenBodyState();
}

class _PetsScreenBodyState extends State<_PetsScreenBody> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? currentUserId;
  String? speciesFilter;
  String? colorFilter;
  String? breedFilter;
  String? searchQuery;
  String? adoptedStatusFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _fetchTabPets(reset: true);
    }
  }

  void _fetchTabPets({bool reset = false}) {
    final cubit = context.read<PetCubit>();
    String? adoptedStatus;
    if (_tabController.index == 1) adoptedStatus = 'owned';
    if (_tabController.index == 2) adoptedStatus = 'waiting';
    cubit.fetchPets(
      reset: reset,
      adoptedStatus: adoptedStatusFilter ?? adoptedStatus,
      species: speciesFilter,
      color: colorFilter,
      breed: breedFilter,
      search: searchQuery,
    );
  }

  void _openFilterModal(BuildContext context) async {
    String? tempSpecies = speciesFilter;
    String? tempColor = colorFilter;
    String? tempBreed = breedFilter;
    String? tempAdoptedStatus = adoptedStatusFilter;

    final speciesOptions = <String?>[null, 'Kedi', 'Köpek', 'Kuş', 'Hamster'];
    final colorOptions = <String?>[null, 'Siyah', 'Beyaz', 'Kahverengi', 'Sarı', 'Gri'];
    final breedOptions = <String?>[null, 'Tekir', 'Golden', 'Sarman', 'Haski', 'Papağan'];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final colorScheme = Theme.of(ctx).colorScheme;
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
                          color: colorScheme.onSurface.withOpacity(0.15),
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
                        hintText: 'Tümü',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      items: speciesOptions.map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s ?? 'Tümü'),
                      )).toList(),
                      onChanged: (v) => setModalState(() => tempSpecies = v),
                    ),
                    const SizedBox(height: 14),
                    Text('Renk', style: Theme.of(context).textTheme.labelLarge),
                    DropdownButtonFormField<String>(
                      value: tempColor,
                      isDense: true,
                      decoration: InputDecoration(
                        hintText: 'Tümü',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      items: colorOptions.map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c ?? 'Tümü'),
                      )).toList(),
                      onChanged: (v) => setModalState(() => tempColor = v),
                    ),
                    const SizedBox(height: 14),
                    Text('Cins', style: Theme.of(context).textTheme.labelLarge),
                    DropdownButtonFormField<String>(
                      value: tempBreed,
                      isDense: true,
                      decoration: InputDecoration(
                        hintText: 'Tümü',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      items: breedOptions.map((b) => DropdownMenuItem(
                        value: b,
                        child: Text(b ?? 'Tümü'),
                      )).toList(),
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
                      items: [
                        DropdownMenuItem(value: null, child: Text('Tümü')),
                        DropdownMenuItem(value: 'owned', child: Text('Sahiplenilmiş')),
                        DropdownMenuItem(value: 'waiting', child: Text('Sahiplenilmeyi Bekleyen')),
                      ],
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
                            _fetchTabPets(reset: true);
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
                            // Eğer sahiplenme durumu seçildiyse, tabı da ona göre değiştir
                            if (tempAdoptedStatus == 'owned') {
                              _tabController.animateTo(1);
                            } else if (tempAdoptedStatus == 'waiting') {
                              _tabController.animateTo(2);
                            } else {
                              _tabController.animateTo(0);
                            }
                            _fetchTabPets(reset: true);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('pets.title'.tr()),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _openFilterModal(context),
            tooltip: 'Filtrele',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'pets.tab_all'.tr()),
            Tab(text: 'pets.tab_owned'.tr()),
            Tab(text: 'pets.tab_waiting'.tr()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PetListTab(
            adoptedStatus: null,
            species: speciesFilter,
            color: colorFilter,
            breed: breedFilter,
            search: searchQuery,
          ),
          _PetListTab(
            adoptedStatus: 'owned',
            species: speciesFilter,
            color: colorFilter,
            breed: breedFilter,
            search: searchQuery,
          ),
          _PetListTab(
            adoptedStatus: 'waiting',
            species: speciesFilter,
            color: colorFilter,
            breed: breedFilter,
            search: searchQuery,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'pets_screen_fab',
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddPetScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _PetListTab extends StatelessWidget {
  final String? adoptedStatus;
  final String? species;
  final String? color;
  final String? breed;
  final String? search;
  const _PetListTab({this.adoptedStatus, this.species, this.color, this.breed, this.search});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetCubit>().fetchPets(
        reset: true,
        species: species,
        color: color,
        breed: breed,
        search: search,
      );
    });
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        if (state is PetLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PetError) {
          return Center(child: Text('pets.error'.tr() + '\n' + state.error));
        } else if (state is PetLoaded) {
          List pets = state.pets;
          // Tab'a göre isAdopted filtrelemesi uygula
          if (adoptedStatus == 'owned') {
            pets = pets.where((pet) => pet.isAdopted == true).toList();
          } else if (adoptedStatus == 'waiting') {
            pets = pets.where((pet) => pet.isAdopted == false).toList();
          }
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
                  isMine: false,
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