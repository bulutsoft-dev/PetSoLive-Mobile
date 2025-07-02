// Pet entity burada olacak 

class Pet {
  final int id;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String gender;
  final int ownerId;
  final String? imageUrl;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    required this.ownerId,
    this.imageUrl,
  });
} 