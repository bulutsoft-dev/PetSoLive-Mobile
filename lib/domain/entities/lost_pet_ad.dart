// Lost pet ad entity burada olacak 

class LostPetAd {
  final int id;
  final int petId;
  final String lastSeenLocation;
  final DateTime lostDate;
  final String status;

  LostPetAd({
    required this.id,
    required this.petId,
    required this.lastSeenLocation,
    required this.lostDate,
    required this.status,
  });
} 