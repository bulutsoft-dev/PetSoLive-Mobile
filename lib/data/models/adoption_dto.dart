class AdoptionDto {
  final int id;
  final int petId;
  final String? petName;
  final int userId;
  final String? userName;
  final DateTime adoptionDate;
  final String status;

  AdoptionDto({
    required this.id,
    required this.petId,
    this.petName,
    required this.userId,
    this.userName,
    required this.adoptionDate,
    required this.status,
  });

  factory AdoptionDto.fromJson(Map<String, dynamic> json) {
    return AdoptionDto(
      id: json['id'],
      petId: json['petId'],
      petName: json['petName'] ?? '',
      userId: json['userId'],
      userName: json['userName'] ?? '',
      adoptionDate: DateTime.parse(json['adoptionDate']),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'petName': petName,
    'userId': userId,
    'userName': userName,
    'adoptionDate': adoptionDate.toIso8601String(),
    'status': status,
  };
} 