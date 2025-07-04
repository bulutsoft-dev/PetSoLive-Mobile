// Comment entity burada olacak 

import 'help_request.dart';
import 'user.dart';
import 'veterinarian.dart';

class Comment {
  final int id;
  final int helpRequestId;
  final HelpRequest helpRequest;
  final int userId;
  final User user;
  final int? veterinarianId;
  final Veterinarian? veterinarian;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.helpRequestId,
    required this.helpRequest,
    required this.userId,
    required this.user,
    this.veterinarianId,
    this.veterinarian,
    required this.content,
    required this.createdAt,
  });
} 