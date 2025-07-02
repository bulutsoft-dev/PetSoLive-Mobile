class RegisterDto {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;
  final String? profileImageUrl;
  final String? city;
  final String? district;

  RegisterDto({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    this.profileImageUrl,
    this.city,
    this.district,
  });

  factory RegisterDto.fromJson(Map<String, dynamic> json) {
    return RegisterDto(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      profileImageUrl: json['profileImageUrl'],
      city: json['city'],
      district: json['district'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'address': address,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'profileImageUrl': profileImageUrl,
    'city': city,
    'district': district,
  };
} 