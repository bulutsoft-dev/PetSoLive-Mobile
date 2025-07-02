class HelpRequestDto {
  final int id;
  final int userId;
  final String description;
  final String emergencyLevel;
  final DateTime createdAt;

  HelpRequestDto({
    required this.id,
    required this.userId,
    required this.description,
    required this.emergencyLevel,
    required this.createdAt,
  });

  factory HelpRequestDto.fromJson(Map<String, dynamic> json) {
    return HelpRequestDto(
      id: json['id'],
      userId: json['userId'],
      description: json['description'],
      emergencyLevel: json['emergencyLevel'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'description': description,
    'emergencyLevel': emergencyLevel,
    'createdAt': createdAt.toIso8601String(),
  };
} 