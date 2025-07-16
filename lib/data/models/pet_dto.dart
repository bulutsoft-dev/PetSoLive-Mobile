import 'package:hive/hive.dart';

part 'pet_dto.g.dart';

@HiveType(typeId: 0)
class PetDto {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String species;
  @HiveField(3)
  final String breed;
  @HiveField(4)
  final int age;
  @HiveField(5)
  final String gender;
  @HiveField(6)
  final double weight;
  @HiveField(7)
  final String color;
  @HiveField(8)
  final DateTime dateOfBirth;
  @HiveField(9)
  final String description;
  @HiveField(10)
  final String vaccinationStatus;
  @HiveField(11)
  final String microchipId;
  @HiveField(12)
  final bool? isNeutered;
  @HiveField(13)
  final String imageUrl;
  @HiveField(14)
  final int? ownerId;

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
    this.ownerId,
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
      ownerId: json['ownerId'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
    'id': id,
    'name': name,
    'species': species,
    'breed': breed,
    'age': age,
    'gender': gender,
    'weight': weight,
    'color': color,
      'dateOfBirth': dateOfBirth.toUtc().toIso8601String(),
    'description': description,
    'vaccinationStatus': vaccinationStatus,
    'microchipId': microchipId,
    'isNeutered': isNeutered,
    'imageUrl': imageUrl,
  };
    if (ownerId != null) {
      map['ownerId'] = ownerId;
    }
    // Remove null values (for any optional fields)
    map.removeWhere((key, value) => value == null);
    return map;
  }

  PetDto copyWith({
    int? id,
    String? name,
    String? species,
    String? breed,
    int? age,
    String? gender,
    double? weight,
    String? color,
    DateTime? dateOfBirth,
    String? description,
    String? vaccinationStatus,
    String? microchipId,
    bool? isNeutered,
    String? imageUrl,
    int? ownerId,
  }) {
    return PetDto(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      description: description ?? this.description,
      vaccinationStatus: vaccinationStatus ?? this.vaccinationStatus,
      microchipId: microchipId ?? this.microchipId,
      isNeutered: isNeutered ?? this.isNeutered,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
    );
  }
} 