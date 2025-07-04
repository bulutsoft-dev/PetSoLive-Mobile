class CommentDto {
  final int id;
  final int userId;
  final String content;
  final DateTime createdAt;

  CommentDto({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    return CommentDto(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
  };
} 