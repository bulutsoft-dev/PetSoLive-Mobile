class LostPetAdDto {
  final int id;
  final String petName;
  final String description;
  final DateTime lastSeenDate;
  final String imageUrl;
  final int userId;
  final String lastSeenCity;
  final String lastSeenDistrict;
  final DateTime createdAt;
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