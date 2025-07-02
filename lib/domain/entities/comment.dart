// Comment entity burada olacak 

class Comment {
  final int id;
  final int userId;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });
} 