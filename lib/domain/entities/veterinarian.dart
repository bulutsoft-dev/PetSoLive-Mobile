// Veterinarian entity burada olacak 

class Veterinarian {
  final int id;
  final String name;
  final String clinicName;
  final String phoneNumber;
  final String email;
  final String? address;

  Veterinarian({
    required this.id,
    required this.name,
    required this.clinicName,
    required this.phoneNumber,
    required this.email,
    this.address,
  });
} 