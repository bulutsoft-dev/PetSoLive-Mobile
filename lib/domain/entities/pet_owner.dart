// Pet owner entity burada olacak 

import 'pet.dart';
import 'user.dart';

class PetOwner {
  final int petId;
  final Pet pet;
  final int userId;
  final User user;
  final DateTime ownershipDate;

  PetOwner({
    required this.petId,
    required this.pet,
    required this.userId,
    required this.user,
    required this.ownershipDate,
  });
} 