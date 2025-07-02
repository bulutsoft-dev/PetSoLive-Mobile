class PetDto {
  final int id;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String gender;
  final int ownerId;
  final String? imageUrl;

  PetDto({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    required this.ownerId,
    this.imageUrl,
  });

  factory PetDto.fromJson(Map<String, dynamic> json) {
    return PetDto(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      breed: json['breed'],
      age: json['age'],
      gender: json['gender'],
      ownerId: json['ownerId'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'species': species,
    'breed': breed,
    'age': age,
    'gender': gender,
    'ownerId': ownerId,
    'imageUrl': imageUrl,
  };
} 