class RegisterDto {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;
  final String city;
  final String district;
  final String? profileImageUrl;

  RegisterDto({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    required this.city,
    required this.district,
    this.profileImageUrl,
  });

  factory RegisterDto.fromJson(Map<String, dynamic> json) {
    return RegisterDto(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      city: json['city'],
      district: json['district'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'address': address,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'profileImageUrl': profileImageUrl ?? 'https://www.petsolive.com.tr/',
    'city': city,
    'district': district,
  };
} 