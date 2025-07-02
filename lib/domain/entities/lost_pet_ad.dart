// Lost pet ad entity burada olacak 

import 'user.dart';

class LostPetAd {
  final int id;
  final String petName;
  final String description;
  final DateTime lastSeenDate;
  final String imageUrl;
  final int userId;
  final User user;
  final String lastSeenCity;
  final String lastSeenDistrict;
  final DateTime createdAt;

  LostPetAd({
    required this.id,
    required this.petName,
    required this.description,
    required this.lastSeenDate,
    required this.imageUrl,
    required this.userId,
    required this.user,
    required this.lastSeenCity,
    required this.lastSeenDistrict,
    required this.createdAt,
  });

  String get lastSeenLocation => '[$lastSeenCity, $lastSeenDistrict';
} 