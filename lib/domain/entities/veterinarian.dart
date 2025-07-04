// Veterinarian entity burada olacak 

import 'package:petsolive/core/enums/veterinarian_status.dart';

import 'comment.dart';
import 'user.dart';

class Veterinarian {
  final int id;
  final int userId;
  final User user;
  final String qualifications;
  final String clinicAddress;
  final String clinicPhoneNumber;
  final DateTime appliedDate;
  final VeterinarianStatus status;
  final List<Comment> comments;

  Veterinarian({
    required this.id,
    required this.userId,
    required this.user,
    required this.qualifications,
    required this.clinicAddress,
    required this.clinicPhoneNumber,
    required this.appliedDate,
    required this.status,
    this.comments = const [],
  });
} 