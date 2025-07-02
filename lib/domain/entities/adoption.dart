// Adoption entity burada olacak 

class Adoption {
  final int id;
  final int petId;
  final int adopterId;
  final DateTime adoptionDate;

  Adoption({
    required this.id,
    required this.petId,
    required this.adopterId,
    required this.adoptionDate,
  });
} 