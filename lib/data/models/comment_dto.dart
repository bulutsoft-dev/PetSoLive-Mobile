class CommentDto {
  final int id;
  final int helpRequestId;
  final int userId;
  final String? userName;
  final int? veterinarianId;
  final String? veterinarianName;
  final String content;
  final DateTime createdAt;

  CommentDto({
    required this.id,
    required this.helpRequestId,
    required this.userId,
    this.userName,
    this.veterinarianId,
    this.veterinarianName,
    required this.content,
    required this.createdAt,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    return CommentDto(
      id: json['id'],
      helpRequestId: json['helpRequestId'],
      userId: json['userId'],
      userName: json['userName'],
      veterinarianId: json['veterinarianId'],
      veterinarianName: json['veterinarianName'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'helpRequestId': helpRequestId,
    'userId': userId,
    'userName': userName,
    'veterinarianId': veterinarianId,
    'veterinarianName': veterinarianName,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
  };
} 