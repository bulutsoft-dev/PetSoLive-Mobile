class PetOwnerDto {
  final int petId;
  final String petName;
  final int userId;
  final String userName;
  final DateTime ownershipDate;

  PetOwnerDto({
    required this.petId,
    required this.petName,
    required this.userId,
    required this.userName,
    required this.ownershipDate,
  });

  factory PetOwnerDto.fromJson(Map<String, dynamic> json) {
    return PetOwnerDto(
      petId: json['petId'],
      petName: json['petName'],
      userId: json['userId'],
      userName: json['userName'],
      ownershipDate: DateTime.parse(json['ownershipDate']),
    );
  }

  Map<String, dynamic> toJson() => {
    'petId': petId,
    'petName': petName,
    'userId': userId,
    'userName': userName,
    'ownershipDate': ownershipDate.toIso8601String(),
  };
} 