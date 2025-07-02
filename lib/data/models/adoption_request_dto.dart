class AdoptionRequestDto {
  final int id;
  final int petId;
  final String petName;
  final int userId;
  final String userName;
  final String? message;
  final String status;
  final DateTime requestDate;

  AdoptionRequestDto({
    required this.id,
    required this.petId,
    required this.petName,
    required this.userId,
    required this.userName,
    this.message,
    required this.status,
    required this.requestDate,
  });

  factory AdoptionRequestDto.fromJson(Map<String, dynamic> json) {
    return AdoptionRequestDto(
      id: json['id'],
      petId: json['petId'],
      petName: json['petName'],
      userId: json['userId'],
      userName: json['userName'],
      message: json['message'],
      status: json['status'],
      requestDate: DateTime.parse(json['requestDate']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'petName': petName,
    'userId': userId,
    'userName': userName,
    'message': message,
    'status': status,
    'requestDate': requestDate.toIso8601String(),
  };
} 