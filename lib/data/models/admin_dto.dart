class AdminDto {
  final int id;
  final String name;
  final String email;

  AdminDto({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AdminDto.fromJson(Map<String, dynamic> json) {
    return AdminDto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
} 