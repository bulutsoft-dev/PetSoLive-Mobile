class AdoptionDto {
  final int id;
  final int petId;
  final int adopterId;
  final DateTime adoptionDate;

  AdoptionDto({
    required this.id,
    required this.petId,
    required this.adopterId,
    required this.adoptionDate,
  });

  factory AdoptionDto.fromJson(Map<String, dynamic> json) {
    return AdoptionDto(
      id: json['id'],
      petId: json['petId'],
      adopterId: json['adopterId'],
      adoptionDate: DateTime.parse(json['adoptionDate']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'adopterId': adopterId,
    'adoptionDate': adoptionDate.toIso8601String(),
  };
} 