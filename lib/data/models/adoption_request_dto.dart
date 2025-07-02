class AdoptionRequestDto {
  final int id;
  final int adoptionId;
  final int requesterId;
  final String status;
  final DateTime requestDate;

  AdoptionRequestDto({
    required this.id,
    required this.adoptionId,
    required this.requesterId,
    required this.status,
    required this.requestDate,
  });

  factory AdoptionRequestDto.fromJson(Map<String, dynamic> json) {
    return AdoptionRequestDto(
      id: json['id'],
      adoptionId: json['adoptionId'],
      requesterId: json['requesterId'],
      status: json['status'],
      requestDate: DateTime.parse(json['requestDate']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'adoptionId': adoptionId,
    'requesterId': requesterId,
    'status': status,
    'requestDate': requestDate.toIso8601String(),
  };
} 