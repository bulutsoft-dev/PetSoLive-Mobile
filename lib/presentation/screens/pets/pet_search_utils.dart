import '../../../data/models/pet_list_item.dart';

String normalize(String input) {
  return input
      .toLowerCase()
      .replaceAll('ç', 'c')
      .replaceAll('ğ', 'g')
      .replaceAll('ı', 'i')
      .replaceAll('ö', 'o')
      .replaceAll('ş', 's')
      .replaceAll('ü', 'u')
      .replaceAll('â', 'a')
      .replaceAll('î', 'i')
      .replaceAll('û', 'u');
}

List<PetListItem> filterPets(
  List<PetListItem> pets,
  String? search, {
  String? species,
  String? color,
  String? breed,
  String? adoptedStatus,
  int? currentUserId,
  bool myPetsOnly = false,
}) {
  final q = normalize(search ?? '');
  var filtered = pets;
  if (q.isNotEmpty) {
    filtered = filtered.where((pet) {
      final fields = [
        pet.name,
        pet.species,
        pet.breed,
        pet.color,
        pet.description,
        pet.age?.toString(),
        pet.gender,
        pet.vaccinationStatus,
        pet.ownerId?.toString(),
        pet.adoptedOwnerName
      ];
      final normalizedFields = fields.map((f) => normalize(f ?? '')).join(' ');
      return q.split('').every((char) => normalizedFields.contains(char));
    }).toList();
  }
  if (species != null && species.isNotEmpty) {
    filtered = filtered.where((pet) => pet.species == species).toList();
  }
  if (color != null && color.isNotEmpty) {
    filtered = filtered.where((pet) => pet.color == color).toList();
  }
  if (breed != null && breed.isNotEmpty) {
    filtered = filtered.where((pet) => pet.breed == breed).toList();
  }
  if (myPetsOnly && currentUserId != null) {
    filtered = filtered.where((pet) => pet.ownerId == currentUserId).toList();
  } else if (adoptedStatus == 'owned') {
    filtered = filtered.where((pet) => pet.isAdopted == true).toList();
  } else if (adoptedStatus == 'waiting') {
    filtered = filtered.where((pet) => pet.isAdopted == false).toList();
  }
  return filtered;
} 