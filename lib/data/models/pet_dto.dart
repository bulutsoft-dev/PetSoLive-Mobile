class PetDto {
  final int id;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String gender;
  final double weight;
  final String color;
  final DateTime dateOfBirth;
  final String description;
  final String vaccinationStatus;
  final String microchipId;
  final bool? isNeutered;
  final String imageUrl;

  PetDto({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    required this.weight,
    required this.color,
    required this.dateOfBirth,
    required this.description,
    required this.vaccinationStatus,
    required this.microchipId,
    this.isNeutered,
    required this.imageUrl,
  });

  factory PetDto.fromJson(Map<String, dynamic> json) {
    return PetDto(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      breed: json['breed'],
      age: json['age'] is int ? json['age'] : int.tryParse(json['age'].toString()) ?? 0,
      gender: json['gender'],
      weight: (json['weight'] as num).toDouble(),
      color: json['color'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      description: json['description'],
      vaccinationStatus: json['vaccinationStatus'],
      microchipId: json['microchipId'],
      isNeutered: json['isNeutered'],
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
    'weight': weight,
    'color': color,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'description': description,
    'vaccinationStatus': vaccinationStatus,
    'microchipId': microchipId,
    'isNeutered': isNeutered,
    'imageUrl': imageUrl,
  };
} 