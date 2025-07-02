// Adoption request entity burada olacak 

class AdoptionRequest {
  final int id;
  final int adoptionId;
  final int requesterId;
  final String status;
  final DateTime requestDate;

  AdoptionRequest({
    required this.id,
    required this.adoptionId,
    required this.requesterId,
    required this.status,
    required this.requestDate,
  });
} 