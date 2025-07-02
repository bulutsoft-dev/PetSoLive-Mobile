class LostPetAdDto {
  final int id;
  final int petId;
  final String lastSeenLocation;
  final DateTime lostDate;
  final String status;

  LostPetAdDto({
    required this.id,
    required this.petId,
    required this.lastSeenLocation,
    required this.lostDate,
    required this.status,
  });

  factory LostPetAdDto.fromJson(Map<String, dynamic> json) {
    return LostPetAdDto(
      id: json['id'],
      petId: json['petId'],
      lastSeenLocation: json['lastSeenLocation'],
      lostDate: DateTime.parse(json['lostDate']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'lastSeenLocation': lastSeenLocation,
    'lostDate': lostDate.toIso8601String(),
    'status': status,
  };
} 