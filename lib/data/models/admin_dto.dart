class AdminDto {
  final int id;
  final int userId;
  final String userName;
  final DateTime createdDate;

  AdminDto({
    required this.id,
    required this.userId,
    required this.userName,
    required this.createdDate,
  });

  factory AdminDto.fromJson(Map<String, dynamic> json) {
    return AdminDto(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'createdDate': createdDate.toIso8601String(),
  };
} 