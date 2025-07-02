class VeterinarianDto {
  final int id;
  final String name;
  final String clinicName;
  final String phoneNumber;
  final String email;
  final String? address;

  VeterinarianDto({
    required this.id,
    required this.name,
    required this.clinicName,
    required this.phoneNumber,
    required this.email,
    this.address,
  });

  factory VeterinarianDto.fromJson(Map<String, dynamic> json) {
    return VeterinarianDto(
      id: json['id'],
      name: json['name'],
      clinicName: json['clinicName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'clinicName': clinicName,
    'phoneNumber': phoneNumber,
    'email': email,
    'address': address,
  };
} 