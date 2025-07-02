class UserDto {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? address;
  final DateTime? createdAt;

  UserDto({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.address,
    this.createdAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
    'createdAt': createdAt?.toIso8601String(),
  };
} 