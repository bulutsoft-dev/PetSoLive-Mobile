// Adoption entity burada olacak 

import 'package:petsolive/core/enums/adoption_status.dart';

import 'pet.dart';
import 'user.dart';

class Adoption {
  final int id;
  final int petId;
  final int userId;
  final DateTime adoptionDate;
  final AdoptionStatus status;
  final Pet pet;
  final User user;

  Adoption({
    required this.id,
    required this.petId,
    required this.userId,
    required this.adoptionDate,
    required this.status,
    required this.pet,
    required this.user,
  });
} 