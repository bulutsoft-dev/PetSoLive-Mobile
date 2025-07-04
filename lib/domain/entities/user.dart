// User entity burada olacak 

class User {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? address;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.address,
    this.createdAt,
  });
} 