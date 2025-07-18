class PetListItem {
  final int id;
  final String name;
  final String species;
  final String breed;
  final String color;
  final int age;
  final String gender;
  final String imageUrl;
  final String description;
  final String vaccinationStatus;
  final bool isAdopted;
  final String? adoptedOwnerName;
  final int ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PetListItem({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.color,
    required this.age,
    required this.gender,
    required this.imageUrl,
    required this.description,
    required this.vaccinationStatus,
    required this.isAdopted,
    this.adoptedOwnerName,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
  });

  factory PetListItem.fromJson(Map<String, dynamic> json) {
    return PetListItem(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      breed: json['breed'],
      color: json['color'],
      age: json['age'],
      gender: json['gender'],
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      vaccinationStatus: json['vaccinationStatus'] ?? '',
      isAdopted: json['isAdopted'],
      adoptedOwnerName: json['adoptedOwnerName'],
      ownerId: json['ownerId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
} 