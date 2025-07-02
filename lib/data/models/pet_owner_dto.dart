class PetOwnerDto {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;

  PetOwnerDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory PetOwnerDto.fromJson(Map<String, dynamic> json) {
    return PetOwnerDto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
  };
} 