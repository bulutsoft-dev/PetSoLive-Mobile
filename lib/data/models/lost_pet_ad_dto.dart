import 'package:hive/hive.dart';

part 'lost_pet_ad_dto.g.dart';

@HiveType(typeId: 1)
class LostPetAdDto {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String petName;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final DateTime lastSeenDate;
  @HiveField(4)
  final String imageUrl;
  @HiveField(5)
  final int userId;
  @HiveField(6)
  final String lastSeenCity;
  @HiveField(7)
  final String lastSeenDistrict;
  @HiveField(8)
  final DateTime createdAt;
  @HiveField(9)
  final String userName;

  LostPetAdDto({
    required this.id,
    required this.petName,
    required this.description,
    required this.lastSeenDate,
    required this.imageUrl,
    required this.userId,
    required this.lastSeenCity,
    required this.lastSeenDistrict,
    required this.createdAt,
    required this.userName,
  });

  String get lastSeenLocation => '[$lastSeenCity, $lastSeenDistrict';

  factory LostPetAdDto.fromJson(Map<String, dynamic> json) {
    return LostPetAdDto(
      id: json['id'],
      petName: json['petName'] ?? '',
      description: json['description'] ?? '',
      lastSeenDate: DateTime.parse(json['lastSeenDate']),
      imageUrl: json['imageUrl'] ?? '',
      userId: json['userId'],
      lastSeenCity: json['lastSeenCity'] ?? '',
      lastSeenDistrict: json['lastSeenDistrict'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      userName: json['userName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'petName': petName,
    'description': description,
    'lastSeenDate': lastSeenDate.toIso8601String(),
    'imageUrl': imageUrl,
    'userId': userId,
    'lastSeenCity': lastSeenCity,
    'lastSeenDistrict': lastSeenDistrict,
    'createdAt': createdAt.toIso8601String(),
    'userName': userName,
  };
} 