import 'package:petsolive/domain/entities/user.dart';

class Admin {
  final int id;
  final int userId;
  final DateTime createdDate;
  final User user;

  Admin({
    required this.id,
    required this.userId,
    required this.createdDate,
    required this.user,
  });
} 