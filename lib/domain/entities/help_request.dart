class HelpRequest {
  final int id;
  final int userId;
  final String description;
  final String emergencyLevel;
  final DateTime createdAt;

  HelpRequest({
    required this.id,
    required this.userId,
    required this.description,
    required this.emergencyLevel,
    required this.createdAt,
  });
} 