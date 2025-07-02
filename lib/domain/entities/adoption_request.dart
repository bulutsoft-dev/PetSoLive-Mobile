// Adoption request entity burada olacak 

import 'adoption_status.dart';
import 'pet.dart';
import 'user.dart';

class AdoptionRequest {
  final int id;
  final int petId;
  final int userId;
  final String? message;
  final AdoptionStatus status;
  final DateTime requestDate;
  final Pet pet;
  final User user;

  AdoptionRequest({
    required this.id,
    required this.petId,
    required this.userId,
    this.message,
    required this.status,
    required this.requestDate,
    required this.pet,
    required this.user,
  });
} 