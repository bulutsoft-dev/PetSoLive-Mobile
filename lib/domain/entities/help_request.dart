import 'package:petsolive/core/enums/emergency_level.dart';
import 'package:petsolive/core/enums/help_request_status.dart';

import 'comment.dart';
import 'user.dart';

class HelpRequest {
  final int id;
  final String title;
  final String description;
  final EmergencyLevel emergencyLevel;
  final DateTime createdAt;
  final int userId;
  final User? user;
  final String location;
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;
  final String? imageUrl;
  final HelpRequestStatus status;
  final List<Comment>? comments;

  HelpRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.emergencyLevel,
    required this.createdAt,
    required this.userId,
    this.user,
    required this.location,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.imageUrl,
    required this.status,
    this.comments,
  });
} 