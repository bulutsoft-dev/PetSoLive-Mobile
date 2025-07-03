class PetOwnerDto {
  final int petId;
  final String? petName;
  final int userId;
  final String? userName;
  final DateTime? ownershipDate;

  PetOwnerDto({
    required this.petId,
    this.petName,
    required this.userId,
    this.userName,
    this.ownershipDate,
  });

  factory PetOwnerDto.fromJson(Map<String, dynamic> json) {
    return PetOwnerDto(
      petId: json['petId'],
      petName: json['petName'] as String?,
      userId: json['userId'],
      userName: json['userName'] as String?,
      ownershipDate: json['ownershipDate'] != null && json['ownershipDate'].toString().isNotEmpty
          ? DateTime.tryParse(json['ownershipDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'petId': petId,
    'petName': petName,
    'userId': userId,
    'userName': userName,
    'ownershipDate': ownershipDate?.toIso8601String(),
  };
} 